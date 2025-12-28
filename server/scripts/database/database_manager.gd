extends Node
class_name DatabaseManager

## Gerenciador de banco de dados do servidor
## Usa SQLite - simples, rápido e gratuito

signal database_initialized
signal database_error(message: String)

# Caminho será determinado dinamicamente
var database_path: String

var db: SQLite
var is_initialized: bool = false

func _ready() -> void:
	initialize_database()

func initialize_database() -> void:
	# Verificar se a classe SQLite está disponível
	if not ClassDB.class_exists("SQLite"):
		push_error("Plugin SQLite não encontrado! Por favor, instale o plugin godot-sqlite.")
		push_error("Instruções em: addons/godot-sqlite/INSTALL.md")
		database_error.emit("Plugin SQLite não encontrado")
		return
	
	# Determinar caminho do banco
	database_path = DatabaseConfig.get_database_path()
	
	# Criar diretório se necessário (para Docker/produção)
	if database_path.begins_with("/"):
		var dir_path = database_path.get_base_dir()
		if not DirAccess.dir_exists_absolute(dir_path):
			var dir = DirAccess.open("res://")
			if dir:
				dir.make_dir_recursive(dir_path)
	
	db = SQLite.new()
	
	var error = db.open(database_path)
	if error != OK:
		push_error("Erro ao abrir banco de dados: " + str(error))
		database_error.emit("Erro ao abrir banco de dados")
		return
	
	# Configurar performance do SQLite usando configurações externas
	configure_sqlite()
	
	create_tables()
	is_initialized = true
	database_initialized.emit()
	print("Banco de dados SQLite inicializado com sucesso em: ", database_path)

func create_tables() -> void:
	# Tabela de usuários
	var create_users_table = """
		CREATE TABLE IF NOT EXISTS users (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			username VARCHAR(50) UNIQUE NOT NULL,
			email VARCHAR(100) UNIQUE NOT NULL,
			password_hash VARCHAR(255) NOT NULL,
			salt VARCHAR(255) NOT NULL,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			last_login TIMESTAMP
		);
	"""
	
	# Tabela de personagens
	var create_characters_table = """
		CREATE TABLE IF NOT EXISTS characters (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			user_id INTEGER NOT NULL,
			name VARCHAR(50) NOT NULL,
			class_type INTEGER NOT NULL DEFAULT 0,
			level INTEGER NOT NULL DEFAULT 1,
			experience INTEGER NOT NULL DEFAULT 0,
			experience_to_next_level INTEGER NOT NULL DEFAULT 100,
			strength INTEGER NOT NULL DEFAULT 0,
			agility INTEGER NOT NULL DEFAULT 0,
			vitality INTEGER NOT NULL DEFAULT 0,
			intelligence INTEGER NOT NULL DEFAULT 0,
			command INTEGER NOT NULL DEFAULT 0,
			available_points INTEGER NOT NULL DEFAULT 0,
			position_x REAL DEFAULT 0.0,
			position_y REAL DEFAULT 0.0,
			position_z REAL DEFAULT 0.0,
			rotation_x REAL DEFAULT 0.0,
			rotation_y REAL DEFAULT 0.0,
			rotation_z REAL DEFAULT 0.0,
			health REAL DEFAULT 100.0,
			max_health REAL DEFAULT 100.0,
			mana REAL DEFAULT 50.0,
			max_mana REAL DEFAULT 50.0,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			last_played TIMESTAMP,
			FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
		);
	"""
	
	# Tabela de inventário
	var create_inventory_table = """
		CREATE TABLE IF NOT EXISTS inventory (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			character_id INTEGER NOT NULL,
			item_id INTEGER NOT NULL,
			slot INTEGER,
			quantity INTEGER NOT NULL DEFAULT 1,
			FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
		);
	"""
	
	# Tabela de equipamentos
	var create_equipment_table = """
		CREATE TABLE IF NOT EXISTS equipment (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			character_id INTEGER NOT NULL,
			slot_type VARCHAR(20) NOT NULL,
			item_id INTEGER,
			FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
			UNIQUE(character_id, slot_type)
		);
	"""
	
	# Executar queries
	execute_query(create_users_table)
	execute_query(create_characters_table)
	execute_query(create_inventory_table)
	execute_query(create_equipment_table)
	
	# Criar índices para performance
	create_indexes()

func configure_sqlite() -> void:
	# Configurar cache size para melhor performance (usando configurações externas)
	var cache_size = DatabaseConfig.get_cache_size()
	var cache_query = "PRAGMA cache_size = -%d" % cache_size
	execute_query(cache_query)
	
	# Configurar journal mode (WAL para melhor performance em leitura/escrita concorrente)
	var journal_mode = DatabaseConfig.get_journal_mode()
	var journal_query = "PRAGMA journal_mode = %s" % journal_mode
	execute_query(journal_query)
	
	# Habilitar foreign keys
	execute_query("PRAGMA foreign_keys = ON")
	
	print("SQLite configurado: cache_size=%dKB, journal_mode=%s" % [cache_size, journal_mode])

func create_indexes() -> void:
	var indexes = [
		"CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);",
		"CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);",
		"CREATE INDEX IF NOT EXISTS idx_characters_user_id ON characters(user_id);",
		"CREATE INDEX IF NOT EXISTS idx_characters_name ON characters(name);",
		"CREATE INDEX IF NOT EXISTS idx_inventory_character_id ON inventory(character_id);",
		"CREATE INDEX IF NOT EXISTS idx_equipment_character_id ON equipment(character_id);"
	]
	
	for index_query in indexes:
		execute_query(index_query)

func execute_query(query: String) -> bool:
	if not is_initialized:
		push_error("Banco de dados não inicializado")
		return false
	
	var error = db.query(query)
	if error != OK:
		push_error("Erro ao executar query: " + query)
		push_error("Erro: " + str(error))
		return false
	
	return true

## Executa query com argumentos (prepared statement - mais seguro)
func execute_query_with_args(query: String, args: Array) -> bool:
	if not is_initialized:
		push_error("Banco de dados não inicializado")
		return false
	
	var error = db.query_with_args(query, args)
	if error != OK:
		push_error("Erro ao executar query: " + query)
		push_error("Erro: " + str(error))
		return false
	
	return true

func execute_query_with_result(query: String) -> Array:
	if not is_initialized:
		push_error("Banco de dados não inicializado")
		return []
	
	# Executar query e buscar resultados
	db.query(query)
	var result = []
	
	# Buscar todas as linhas
	while db.fetch_row():
		var row = {}
		for i in range(db.get_column_count()):
			var column_name = db.get_column_name(i)
			row[column_name] = db.get_column_value(i)
		result.append(row)
	
	return result

func close_database() -> void:
	if db:
		db.close()
		is_initialized = false
		print("Banco de dados fechado")

func _exit_tree() -> void:
	close_database()


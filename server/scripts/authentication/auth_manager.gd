extends Node
class_name AuthManager

## Gerenciador de autenticação do servidor

signal user_registered(user_id: int, username: String)
signal user_logged_in(user_id: int, username: String, character_data: Dictionary)
signal authentication_failed(reason: String)

@export var database_manager: DatabaseManager

var logged_in_users: Dictionary = {} # {peer_id: user_id}

func _ready() -> void:
	if not database_manager:
		push_error("DatabaseManager não configurado no AuthManager")
		return
	
	# Aguardar inicialização do banco
	if not database_manager.is_initialized:
		database_manager.database_initialized.connect(_on_database_ready)
	else:
		_on_database_ready()

func _on_database_ready() -> void:
	print("AuthManager pronto")

## Registra um novo usuário
func register_user(username: String, email: String, password: String, peer_id: int) -> void:
	if not database_manager or not database_manager.is_initialized:
		authentication_failed.emit("Servidor não está pronto")
		return
	
	# Validar dados
	if username.length() < 3 or username.length() > 50:
		authentication_failed.emit("Username deve ter entre 3 e 50 caracteres")
		return
	
	if email.is_empty() or not email.contains("@"):
		authentication_failed.emit("Email inválido")
		return
	
	if password.length() < 6:
		authentication_failed.emit("Senha deve ter pelo menos 6 caracteres")
		return
	
	# Verificar se username já existe (usar prepared statement para segurança)
	var check_username = "SELECT id FROM users WHERE username = ?"
	database_manager.db.query_with_args(check_username, [username])
	if database_manager.db.fetch_row():
		authentication_failed.emit("Username já existe")
		return
	
	# Verificar se email já existe
	var check_email = "SELECT id FROM users WHERE email = ?"
	database_manager.db.query_with_args(check_email, [email])
	if database_manager.db.fetch_row():
		authentication_failed.emit("Email já está em uso")
		return
	
	# Gerar salt e hash da senha
	var salt = generate_salt()
	var password_hash = hash_password(password, salt)
	
	# Inserir usuário no banco (usar prepared statement)
	var insert_query = "INSERT INTO users (username, email, password_hash, salt) VALUES (?, ?, ?, ?)"
	var error = database_manager.db.query_with_args(insert_query, [username, email, password_hash, salt])
	
	if error == OK:
		# Buscar ID do usuário criado
		var user_query = "SELECT id FROM users WHERE username = ?"
		database_manager.db.query_with_args(user_query, [username])
		if database_manager.db.fetch_row():
			var user_id = database_manager.db.get_column_value(0)
			logged_in_users[peer_id] = user_id
			user_registered.emit(user_id, username)
			print("Usuário registrado: ", username, " (ID: ", user_id, ")")
		else:
			authentication_failed.emit("Erro ao criar usuário")
	else:
		authentication_failed.emit("Erro ao registrar usuário")

## Autentica um usuário
func login_user(username: String, password: String, peer_id: int) -> void:
	if not database_manager or not database_manager.is_initialized:
		authentication_failed.emit("Servidor não está pronto")
		return
	
	# Buscar usuário (usar prepared statement)
	var query = "SELECT id, username, password_hash, salt FROM users WHERE username = ?"
	var error = database_manager.db.query_with_args(query, [username])
	
	if error != OK or not database_manager.db.fetch_row():
		authentication_failed.emit("Usuário ou senha incorretos")
		return
	
	var user_id = database_manager.db.get_column_value(0)
	var stored_username = database_manager.db.get_column_value(1)
	var stored_hash = database_manager.db.get_column_value(2)
	var salt = database_manager.db.get_column_value(3)
	
	# Verificar senha
	var input_hash = hash_password(password, salt)
	if input_hash != stored_hash:
		authentication_failed.emit("Usuário ou senha incorretos")
		return
	
	# Atualizar último login
	var update_query = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?"
	database_manager.db.query_with_args(update_query, [user_id])
	
	# Buscar personagem do usuário
	var character_data = get_character_data(user_id)
	
	# Registrar como logado
	logged_in_users[peer_id] = user_id
	
	user_logged_in.emit(user_id, username, character_data)
	print("Usuário logado: ", username, " (ID: ", user_id, ")")

## Busca dados do personagem
func get_character_data(user_id: int) -> Dictionary:
	var query = "SELECT * FROM characters WHERE user_id = ? LIMIT 1"
	var error = database_manager.db.query_with_args(query, [user_id])
	
	if error == OK and database_manager.db.fetch_row():
		var character_data = {}
		for i in range(database_manager.db.get_column_count()):
			var column_name = database_manager.db.get_column_name(i)
			character_data[column_name] = database_manager.db.get_column_value(i)
		return character_data
	else:
		# Criar personagem padrão se não existir
		return create_default_character(user_id)

## Cria um personagem padrão
func create_default_character(user_id: int) -> Dictionary:
	var default_name = "Personagem_" + str(user_id)
	var insert_query = "INSERT INTO characters (user_id, name, class_type, level, experience, experience_to_next_level) VALUES (?, ?, 0, 1, 0, 100)"
	var error = database_manager.db.query_with_args(insert_query, [user_id, default_name])
	
	if error == OK:
		# Buscar personagem criado
		var query = "SELECT * FROM characters WHERE user_id = ? LIMIT 1"
		database_manager.db.query_with_args(query, [user_id])
		if database_manager.db.fetch_row():
			var character_data = {}
			for i in range(database_manager.db.get_column_count()):
				var column_name = database_manager.db.get_column_name(i)
				character_data[column_name] = database_manager.db.get_column_value(i)
			return character_data
	
	return {}

## Desconecta um usuário
func logout_user(peer_id: int) -> void:
	if logged_in_users.has(peer_id):
		logged_in_users.erase(peer_id)
		print("Usuário desconectado (Peer ID: ", peer_id, ")")

## Verifica se um peer está autenticado
func is_authenticated(peer_id: int) -> bool:
	return logged_in_users.has(peer_id)

## Obtém o user_id de um peer
func get_user_id(peer_id: int) -> int:
	return logged_in_users.get(peer_id, -1)

## Gera um salt aleatório
func generate_salt() -> String:
	var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var salt = ""
	for i in range(32):
		salt += chars[randi() % chars.length()]
	return salt

## Hash da senha usando SHA-256 (simplificado - em produção usar bcrypt)
func hash_password(password: String, salt: String) -> String:
	var hash = password + salt
	# Godot não tem SHA-256 nativo, usar método simples para desenvolvimento
	# Em produção, usar uma biblioteca de hash adequada
	return hash.sha256_text()


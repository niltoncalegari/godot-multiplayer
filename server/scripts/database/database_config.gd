extends RefCounted
class_name DatabaseConfig

## Configurações do banco de dados SQLite

# Caminho do banco de dados
# Prioridade: server_data local > Docker > user://
static func get_database_path() -> String:
	# 1. Tentar usar diretório local server_data (mais fácil para DBeaver)
	# Obter diretório do projeto
	var project_path = ProjectSettings.globalize_path("res://")
	var project_dir = project_path.get_base_dir()
	
	# Caminho local do banco
	var local_db_path = project_dir.path_join("server_data/game_database.db")
	var local_dir = project_dir.path_join("server_data")
	
	# Criar diretório se não existir
	var dir = DirAccess.open(project_dir)
	if dir:
		if not dir.dir_exists("server_data"):
			dir.make_dir("server_data")
		# Sempre usar caminho local em desenvolvimento (mais fácil para DBeaver)
		if not OS.has_feature("standalone"):
			return local_db_path
	
	# 2. Em produção Docker
	if OS.has_feature("standalone"):
		return "/app/server_data/game_database.db"
	
	# 3. Fallback: user:// (se não conseguir criar diretório local)
	return "user://game_database.db"

# Configurações de backup
static var AUTO_BACKUP: bool = true
static var BACKUP_INTERVAL_HOURS: int = 6
static var MAX_BACKUPS: int = 10

# Configurações de performance
static var CACHE_SIZE: int = 10000  # KB
static var JOURNAL_MODE: String = "WAL"  # Write-Ahead Logging para melhor performance


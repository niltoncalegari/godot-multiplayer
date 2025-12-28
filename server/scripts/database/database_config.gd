extends RefCounted
class_name DatabaseConfig

## Configurações do banco de dados SQLite

const ConfigManager = preload("res://shared/scripts/config_manager.gd")

static var _config: Dictionary = {}
static var _config_loaded: bool = false

## Carrega configurações do arquivo
static func _load_config() -> void:
	if _config_loaded:
		return
	
	_config = ConfigManager.load_server_config()
	_config_loaded = true

## Caminho do banco de dados
## Prioridade: Configuração externa > server_data local > Docker > user://
static func get_database_path() -> String:
	_load_config()
	
	# Tentar usar configuração externa primeiro
	if _config.has("database") and _config.database.has("path"):
		var config_path = _config.database.path
		# Se é caminho relativo, resolver em relação ao executável/projeto
		if not config_path.begins_with("/") and not config_path.begins_with("user://"):
			var exe_path = OS.get_executable_path()
			if not exe_path.is_empty():
				var exe_dir = exe_path.get_base_dir()
				return exe_dir.path_join(config_path)
			else:
				var project_path = ProjectSettings.globalize_path("res://")
				var project_dir = project_path.get_base_dir()
				return project_dir.path_join(config_path)
		return config_path
	
	# Fallback: comportamento original
	# 1. Tentar usar diretório local server_data (mais fácil para DBeaver)
	var project_path = ProjectSettings.globalize_path("res://")
	var project_dir = project_path.get_base_dir()
	var local_db_path = project_dir.path_join("server_data/game_database.db")
	
	var dir = DirAccess.open(project_dir)
	if dir:
		if not dir.dir_exists("server_data"):
			dir.make_dir("server_data")
		if not OS.has_feature("standalone"):
			return local_db_path
	
	# 2. Em produção Docker
	if OS.has_feature("standalone"):
		return "/app/server_data/game_database.db"
	
	# 3. Fallback: user://
	return "user://game_database.db"

## Configurações de backup
static func get_auto_backup() -> bool:
	_load_config()
	if _config.has("database") and _config.database.has("backup"):
		return _config.database.backup.get("enabled", true)
	return true

static func get_backup_interval_hours() -> int:
	_load_config()
	if _config.has("database") and _config.database.has("backup"):
		return _config.database.backup.get("interval_hours", 6)
	return 6

static func get_max_backups() -> int:
	_load_config()
	if _config.has("database") and _config.database.has("backup"):
		return _config.database.backup.get("max_backups", 10)
	return 10

## Configurações de performance
static func get_cache_size() -> int:
	_load_config()
	if _config.has("database") and _config.database.has("performance"):
		return _config.database.performance.get("cache_size_kb", 10000)
	return 10000  # KB

static func get_journal_mode() -> String:
	_load_config()
	if _config.has("database") and _config.database.has("performance"):
		return _config.database.performance.get("journal_mode", "WAL")
	return "WAL"


extends RefCounted
class_name DatabaseConfig

## Configurações do banco de dados SQLite

# Caminho do banco de dados
# Em desenvolvimento: user://game_database.db (pasta do usuário)
# Em produção (Docker): /app/server_data/game_database.db
static func get_database_path() -> String:
	if OS.has_feature("standalone"):
		# Em produção, usar caminho absoluto
		return "/app/server_data/game_database.db"
	else:
		# Em desenvolvimento, usar user://
		return "user://game_database.db"

# Configurações de backup
static var AUTO_BACKUP: bool = true
static var BACKUP_INTERVAL_HOURS: int = 6
static var MAX_BACKUPS: int = 10

# Configurações de performance
static var CACHE_SIZE: int = 10000  # KB
static var JOURNAL_MODE: String = "WAL"  # Write-Ahead Logging para melhor performance


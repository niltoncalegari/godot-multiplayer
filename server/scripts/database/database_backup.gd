extends Node
class_name DatabaseBackup

## Sistema de backup automático do banco de dados SQLite

@export var database_manager: DatabaseManager
@export var enabled: bool = true
@export var backup_interval_hours: float = 6.0
@export var max_backups: int = 10
@export var backup_path: String = "user://backups/"

var backup_timer: Timer

func _ready() -> void:
	if not enabled:
		return
	
	if not database_manager:
		push_error("DatabaseManager não configurado no DatabaseBackup")
		return
	
	# Criar diretório de backups
	var dir = DirAccess.open("user://")
	if dir:
		dir.make_dir_recursive(backup_path)
	
	# Configurar timer para backups automáticos
	backup_timer = Timer.new()
	backup_timer.wait_time = backup_interval_hours * 3600.0  # Converter horas para segundos
	backup_timer.timeout.connect(perform_backup)
	backup_timer.autostart = true
	add_child(backup_timer)
	
	print("Sistema de backup configurado: intervalo de %.1f horas" % backup_interval_hours)

## Realiza backup do banco de dados
func perform_backup() -> void:
	if not database_manager or not database_manager.is_initialized:
		push_error("DatabaseManager não inicializado para backup")
		return
	
	var timestamp = Time.get_datetime_string_from_system(false, true).replace(":", "-").replace(" ", "_")
	var backup_file = backup_path + "game_database_backup_%s.db" % timestamp
	
	# Fechar conexão atual
	database_manager.close_database()
	
	# Copiar arquivo do banco
	var source_file = FileAccess.open(database_manager.database_path, FileAccess.READ)
	if not source_file:
		push_error("Erro ao abrir banco de dados para backup")
		database_manager.initialize_database()
		return
	
	var backup_file_access = FileAccess.open(backup_file, FileAccess.WRITE)
	if not backup_file_access:
		push_error("Erro ao criar arquivo de backup")
		source_file.close()
		database_manager.initialize_database()
		return
	
	# Copiar dados
	var data = source_file.get_buffer(source_file.get_length())
	backup_file_access.store_buffer(data)
	
	source_file.close()
	backup_file_access.close()
	
	# Reabrir banco
	database_manager.initialize_database()
	
	# Limpar backups antigos
	cleanup_old_backups()
	
	print("Backup criado: ", backup_file)

## Remove backups antigos mantendo apenas os mais recentes
func cleanup_old_backups() -> void:
	var dir = DirAccess.open(backup_path)
	if not dir:
		return
	
	var backups = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".db") and file_name.begins_with("game_database_backup_"):
			var file_path = backup_path + file_name
			var file_time = FileAccess.get_modified_time(file_path)
			backups.append({"path": file_path, "time": file_time})
		file_name = dir.get_next()
	
	# Ordenar por data (mais recente primeiro)
	backups.sort_custom(func(a, b): return a.time > b.time)
	
	# Remover backups antigos
	if backups.size() > max_backups:
		for i in range(max_backups, backups.size()):
			DirAccess.remove_absolute(backups[i].path)
			print("Backup antigo removido: ", backups[i].path)

## Cria backup manual
func create_manual_backup() -> void:
	perform_backup()


extends Node
class_name ConfigManager

## Gerenciador de configurações externas via arquivos JSON

static var server_config: Dictionary = {}
static var client_config: Dictionary = {}
static var config_loaded: bool = false

## Carrega configurações do servidor
static func load_server_config(config_path: String = "server_config.json") -> Dictionary:
	var config = {}
	
	# Tentar carregar do diretório do executável primeiro (produção)
	var exe_path = OS.get_executable_path()
	if not exe_path.is_empty():
		var exe_dir = exe_path.get_base_dir()
		var config_file = exe_dir.path_join(config_path)
		if FileAccess.file_exists(config_file):
			config = load_config_file(config_file)
			if not config.is_empty():
				server_config = config
				print("Configuração do servidor carregada de: ", config_file)
				return config
	
	# Tentar carregar do diretório do projeto (desenvolvimento)
	var project_path = ProjectSettings.globalize_path("res://")
	var project_dir = project_path.get_base_dir()
	var local_config = project_dir.path_join(config_path)
	
	if FileAccess.file_exists(local_config):
		config = load_config_file(local_config)
		if not config.is_empty():
			server_config = config
			print("Configuração do servidor carregada de: ", local_config)
			return config
	
	# Se não encontrou, usar valores padrão
	print("Arquivo de configuração não encontrado, usando valores padrão")
	config = get_default_server_config()
	server_config = config
	return config

## Carrega configurações do cliente
static func load_client_config(config_path: String = "client_config.json") -> Dictionary:
	var config = {}
	
	# Tentar carregar do diretório do executável primeiro (produção)
	var exe_path = OS.get_executable_path()
	if not exe_path.is_empty():
		var exe_dir = exe_path.get_base_dir()
		var config_file = exe_dir.path_join(config_path)
		if FileAccess.file_exists(config_file):
			config = load_config_file(config_file)
			if not config.is_empty():
				client_config = config
				print("Configuração do cliente carregada de: ", config_file)
				return config
	
	# Tentar carregar do diretório do projeto (desenvolvimento)
	var project_path = ProjectSettings.globalize_path("res://")
	var project_dir = project_path.get_base_dir()
	var local_config = project_dir.path_join(config_path)
	
	if FileAccess.file_exists(local_config):
		config = load_config_file(local_config)
		if not config.is_empty():
			client_config = config
			print("Configuração do cliente carregada de: ", local_config)
			return config
	
	# Se não encontrou, usar valores padrão
	print("Arquivo de configuração não encontrado, usando valores padrão")
	config = get_default_client_config()
	client_config = config
	return config

## Carrega um arquivo JSON de configuração
static func load_config_file(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Não foi possível abrir arquivo de configuração: " + file_path)
		return {}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("Erro ao parsear JSON de configuração: " + file_path + " - Erro: " + str(error))
		return {}
	
	var config = json.data
	if typeof(config) != TYPE_DICTIONARY:
		push_error("JSON de configuração não é um dicionário válido: " + file_path)
		return {}
	
	return config

## Salva configuração em arquivo JSON
static func save_config_file(file_path: String, config: Dictionary) -> bool:
	var json_string = JSON.stringify(config, "\t")
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		push_error("Não foi possível criar arquivo de configuração: " + file_path)
		return false
	
	file.store_string(json_string)
	file.close()
	print("Configuração salva em: ", file_path)
	return true

## Retorna configuração padrão do servidor
static func get_default_server_config() -> Dictionary:
	return {
		"server": {
			"port": 5050,
			"max_clients": 32,
			"bind_address": "0.0.0.0"
		},
		"database": {
			"type": "sqlite",
			"path": "server_data/game_database.db",
			"backup": {
				"enabled": true,
				"interval_hours": 6,
				"max_backups": 10
			},
			"performance": {
				"cache_size_kb": 10000,
				"journal_mode": "WAL"
			}
		},
		"authentication": {
			"session_timeout_seconds": 3600,
			"max_login_attempts": 5
		}
	}

## Retorna configuração padrão do cliente
static func get_default_client_config() -> Dictionary:
	return {
		"server": {
			"host": "localhost",
			"port": 5050,
			"use_localhost_in_editor": true
		},
		"connection": {
			"timeout_seconds": 10,
			"reconnect_attempts": 3,
			"reconnect_delay_seconds": 2
		}
	}

## Cria arquivos de configuração de exemplo
static func create_example_configs() -> void:
	var project_path = ProjectSettings.globalize_path("res://")
	var project_dir = project_path.get_base_dir()
	
	# Criar server_config.json
	var server_config = get_default_server_config()
	var server_path = project_dir.path_join("server_config.json")
	save_config_file(server_path, server_config)
	
	# Criar client_config.json
	var client_config = get_default_client_config()
	var client_path = project_dir.path_join("client_config.json")
	save_config_file(client_path, client_config)
	
	print("Arquivos de configuração de exemplo criados em: ", project_dir)


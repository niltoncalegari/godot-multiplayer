extends Node
class_name ConnectionClient

const ConnectionBase = preload("res://shared/classes/connection_base.gd")
const ConfigManager = preload("res://shared/scripts/config_manager.gd")

## Gerenciador de conexão do cliente com autenticação

signal connected
signal disconnected
signal authentication_required
signal authentication_success(character_data: Dictionary)
signal authentication_failed(reason: String)

@export var port: int = 5050
@export var host: String = "localhost"
@export var use_localhost_in_editor: bool = true

var is_authenticated: bool = false
var character_data: Dictionary = {}
var config: Dictionary = {}

func _ready() -> void:
	if ConnectionBase.is_server():
		return
	
	# Carregar configurações externas
	config = ConfigManager.load_client_config()
	
	# Aplicar configurações do arquivo (se disponíveis)
	if config.has("server"):
		var server_config = config.server
		if server_config.has("host"):
			host = server_config.host
		if server_config.has("port"):
			port = server_config.port
		if server_config.has("use_localhost_in_editor"):
			use_localhost_in_editor = server_config.use_localhost_in_editor
	
	# Conectar sinais de multiplayer
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connection_failed)

func start_client() -> void:
	var address = host
	if OS.has_feature("editor") and use_localhost_in_editor:
		address = "localhost"
	
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(address, port)
	if err != OK:
		print("Não foi possível conectar ao servidor. Erro: ", err)
		disconnected.emit()
		return
	
	print("Conectando ao servidor...")
	multiplayer.multiplayer_peer = peer

func _on_connected_to_server() -> void:
	print("Conectado ao servidor")
	ConnectionBase.is_peer_connected = true
	connected.emit()
	# Servidor solicitará autenticação via RPC

func _on_server_disconnected() -> void:
	print("Desconectado do servidor")
	ConnectionBase.is_peer_connected = false
	is_authenticated = false
	disconnected.emit()

func _on_connection_failed() -> void:
	print("Falha na conexão com o servidor")
	ConnectionBase.is_peer_connected = false
	disconnected.emit()

## RPC: Solicitação de autenticação do servidor
@rpc("authority", "call_remote", "reliable")
func request_authentication() -> void:
	authentication_required.emit()

## RPC: Enviar registro
func send_register(username: String, email: String, password: String) -> void:
	if not ConnectionBase.is_peer_connected:
		authentication_failed.emit("Não conectado ao servidor")
		return
	
	register_user.rpc_id(1, username, email, password)

## RPC: Enviar login
func send_login(username: String, password: String) -> void:
	if not ConnectionBase.is_peer_connected:
		authentication_failed.emit("Não conectado ao servidor")
		return
	
	login_user.rpc_id(1, username, password)

## RPC: Registro (chamado pelo servidor)
@rpc("any_peer", "call_remote", "reliable")
func register_user(username: String, email: String, password: String) -> void:
	# Implementado no servidor
	pass

## RPC: Login (chamado pelo servidor)
@rpc("any_peer", "call_remote", "reliable")
func login_user(username: String, password: String) -> void:
	# Implementado no servidor
	pass

## RPC: Autenticação bem-sucedida
@rpc("authority", "call_remote", "reliable")
func on_authentication_success(character_data: Dictionary) -> void:
	is_authenticated = true
	self.character_data = character_data
	authentication_success.emit(character_data)
	print("Autenticação bem-sucedida! Personagem: ", character_data.get("name", "Desconhecido"))

## RPC: Autenticação falhou
@rpc("authority", "call_remote", "reliable")
func on_authentication_failed(reason: String) -> void:
	is_authenticated = false
	authentication_failed.emit(reason)
	print("Falha na autenticação: ", reason)


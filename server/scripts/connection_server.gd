extends Node
class_name ConnectionServer

const ConnectionBase = preload("res://shared/classes/connection_base.gd")
const ConfigManager = preload("res://shared/scripts/config_manager.gd")

## Gerenciador de conexão do servidor com autenticação

signal connected
signal disconnected
signal client_authenticated(peer_id: int, user_id: int, character_data: Dictionary)
signal client_authentication_failed(peer_id: int, reason: String)

@export var port: int = 5050
@export var max_clients: int = 32

@export var auth_manager: Node  # AuthManager
@export var character_manager: Node  # CharacterManager
@export var database_manager: Node  # DatabaseManager

var pending_authentications: Dictionary = {} # {peer_id: timestamp}
var config: Dictionary = {}

func _ready() -> void:
	if not ConnectionBase.is_server():
		return
	
	# Carregar configurações externas
	config = ConfigManager.load_server_config()
	
	# Aplicar configurações do arquivo (se disponíveis)
	if config.has("server"):
		var server_config = config.server
		if server_config.has("port"):
			port = server_config.port
		if server_config.has("max_clients"):
			max_clients = server_config.max_clients
	
	# Conectar sinais de autenticação
	if auth_manager:
		if auth_manager.has_signal("user_logged_in"):
			auth_manager.user_logged_in.connect(_on_user_logged_in)
		if auth_manager.has_signal("authentication_failed"):
			auth_manager.authentication_failed.connect(_on_authentication_failed)
		if auth_manager.has_signal("user_registered"):
			auth_manager.user_registered.connect(_on_user_registered)
	
	if character_manager and character_manager.has_signal("character_loaded"):
		character_manager.character_loaded.connect(_on_character_loaded)
	
	# Inicializar servidor
	start_server()

func start_server() -> void:
	if max_clients == 0:
		max_clients = 32
	
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port, max_clients)
	if err != OK:
		print("Não foi possível iniciar servidor. Erro: ", err)
		disconnected.emit()
		return
	else:
		print("Servidor iniciado na porta ", port)
		connected.emit()
	
	multiplayer.multiplayer_peer = peer
	
	# Conectar sinais após criar o peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(peer_id: int) -> void:
	print("Peer conectado: ", peer_id)
	# Cliente tem 30 segundos para se autenticar
	pending_authentications[peer_id] = Time.get_ticks_msec()
	
	# Enviar solicitação de autenticação
	request_authentication.rpc_id(peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer desconectado: ", peer_id)
	pending_authentications.erase(peer_id)
	if auth_manager and auth_manager.has_method("logout_user"):
		auth_manager.logout_user(peer_id)

func _on_user_logged_in(peer_id: int, user_id: int, username: String, character_data: Dictionary) -> void:
	# Carregar personagem completo
	if pending_authentications.has(peer_id):
		pending_authentications.erase(peer_id)
		if character_manager and character_manager.has_method("load_character"):
			character_manager.load_character(user_id, peer_id)

func _on_user_registered(peer_id: int, user_id: int, username: String) -> void:
	# Após registro, usuário já está logado (tratado em _on_user_logged_in)
	pass

func _on_authentication_failed(peer_id: int, reason: String) -> void:
	# Enviar falha para o cliente
	on_authentication_failed.rpc_id(peer_id, reason)

func _on_character_loaded(peer_id: int, character_data: Dictionary) -> void:
	# Personagem carregado, enviar para cliente
	if auth_manager and auth_manager.has_method("get_user_id"):
		var user_id = auth_manager.get_user_id(peer_id)
		client_authenticated.emit(peer_id, user_id, character_data)
		on_authentication_success.rpc_id(peer_id, character_data)

## RPC: Solicita autenticação do cliente
@rpc("any_peer", "call_remote", "reliable")
func request_authentication() -> void:
	# Apenas confirmação, cliente deve enviar credenciais
	pass

## RPC: Registro de novo usuário
@rpc("any_peer", "call_remote", "reliable")
func register_user(username: String, email: String, password: String) -> void:
	var peer_id = multiplayer.get_remote_sender_id()
	
	# Validar que peer está pendente
	if not pending_authentications.has(peer_id):
		on_authentication_failed.rpc_id(peer_id, "Conexão inválida")
		return
	
	# Registrar usuário
	if auth_manager and auth_manager.has_method("register_user"):
		auth_manager.register_user(username, email, password, peer_id)
	else:
		on_authentication_failed.rpc_id(peer_id, "Servidor não configurado")

## RPC: Login de usuário
@rpc("any_peer", "call_remote", "reliable")
func login_user(username: String, password: String) -> void:
	var peer_id = multiplayer.get_remote_sender_id()
	
	# Validar que peer está pendente
	if not pending_authentications.has(peer_id):
		on_authentication_failed.rpc_id(peer_id, "Conexão inválida")
		return
	
	# Fazer login
	if auth_manager and auth_manager.has_method("login_user"):
		auth_manager.login_user(username, password, peer_id)
	else:
		on_authentication_failed.rpc_id(peer_id, "Servidor não configurado")

## RPC: Resposta de autenticação bem-sucedida
@rpc("authority", "call_remote", "reliable")
func on_authentication_success(character_data: Dictionary) -> void:
	# Implementado no cliente
	pass

## RPC: Resposta de autenticação falhou
@rpc("authority", "call_remote", "reliable")
func on_authentication_failed(reason: String) -> void:
	# Implementado no cliente
	pass

## Verifica se peer está autenticado
func is_peer_authenticated(peer_id: int) -> bool:
	if not auth_manager or not auth_manager.has_method("is_authenticated"):
		return false
	return auth_manager.is_authenticated(peer_id)


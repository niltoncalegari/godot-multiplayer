extends Node
class_name ConnectionServer

const ConnectionBase = preload("res://shared/classes/connection_base.gd")

## Gerenciador de conexão do servidor com autenticação

signal connected
signal disconnected
signal client_authenticated(peer_id: int, user_id: int, character_data: Dictionary)
signal client_authentication_failed(peer_id: int, reason: String)

@export var port: int = 5050
@export var max_clients: int = 32

@export var auth_manager: AuthManager
@export var character_manager: CharacterManager
@export var database_manager: DatabaseManager

var pending_authentications: Dictionary = {} # {peer_id: timestamp}

func _ready() -> void:
	if not ConnectionBase.is_server():
		return
	
	# Conectar sinais de autenticação
	if auth_manager:
		auth_manager.user_logged_in.connect(_on_user_logged_in)
		auth_manager.authentication_failed.connect(_on_authentication_failed)
		auth_manager.user_registered.connect(_on_user_registered)
	
	if character_manager:
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
	if auth_manager:
		auth_manager.logout_user(peer_id)

func _on_user_logged_in(user_id: int, username: String, character_data: Dictionary) -> void:
	# Encontrar peer_id associado
	var peer_id = -1
	for pid in pending_authentications.keys():
		if auth_manager.get_user_id(pid) == user_id:
			peer_id = pid
			break
	
	if peer_id != -1:
		pending_authentications.erase(peer_id)
		# Carregar personagem completo
		character_manager.load_character(user_id, peer_id)

func _on_user_registered(user_id: int, username: String) -> void:
	# Após registro, usuário já está logado
	pass

func _on_authentication_failed(reason: String) -> void:
	# Encontrar peer_id que falhou (último que tentou)
	# Isso é uma simplificação - em produção, passar peer_id no sinal
	pass

func _on_character_loaded(peer_id: int, character_data: Dictionary) -> void:
	# Personagem carregado, enviar para cliente
	if auth_manager:
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
		authentication_failed.rpc_id(peer_id, "Conexão inválida")
		return
	
	# Registrar usuário
	if auth_manager:
		auth_manager.register_user(username, email, password, peer_id)
	else:
		authentication_failed.rpc_id(peer_id, "Servidor não configurado")

## RPC: Login de usuário
@rpc("any_peer", "call_remote", "reliable")
func login_user(username: String, password: String) -> void:
	var peer_id = multiplayer.get_remote_sender_id()
	
	# Validar que peer está pendente
	if not pending_authentications.has(peer_id):
		authentication_failed.rpc_id(peer_id, "Conexão inválida")
		return
	
	# Fazer login
	if auth_manager:
		auth_manager.login_user(username, password, peer_id)
	else:
		authentication_failed.rpc_id(peer_id, "Servidor não configurado")

## RPC: Resposta de autenticação bem-sucedida
@rpc("authority", "call_remote", "reliable")
func on_authentication_success(character_data: Dictionary) -> void:
	# Implementado no cliente
	pass

## RPC: Resposta de autenticação falhou
@rpc("authority", "call_remote", "reliable")
func authentication_failed(reason: String) -> void:
	# Implementado no cliente
	pass

## Verifica se peer está autenticado
func is_peer_authenticated(peer_id: int) -> bool:
	if not auth_manager:
		return false
	return auth_manager.is_authenticated(peer_id)


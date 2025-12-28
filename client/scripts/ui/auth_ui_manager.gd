extends Node
class_name AuthUIManager

## Gerenciador de UI de autenticação no cliente

const ConnectionBase = preload("res://shared/classes/connection_base.gd")

@export var connection_client: Node  # ConnectionClient
@export var login_ui: Control  # LoginUI
@export var main_ui: Control  # UI principal do jogo

var is_authenticated: bool = false

func _ready() -> void:
	if ConnectionBase.is_server():
		return
	
	# Conectar sinais
	if connection_client:
		if connection_client.has_signal("authentication_required"):
			connection_client.authentication_required.connect(_on_authentication_required)
		if connection_client.has_signal("authentication_success"):
			connection_client.authentication_success.connect(_on_authentication_success)
		if connection_client.has_signal("authentication_failed"):
			connection_client.authentication_failed.connect(_on_authentication_failed)
		if connection_client.has_signal("connected"):
			connection_client.connected.connect(_on_connected)
		if connection_client.has_signal("disconnected"):
			connection_client.disconnected.connect(_on_disconnected)
	
	if login_ui:
		if login_ui.has_signal("login_requested"):
			login_ui.login_requested.connect(_on_login_requested)
		if login_ui.has_signal("register_requested"):
			login_ui.register_requested.connect(_on_register_requested)
		show_login_ui()

func show_login_ui() -> void:
	if login_ui:
		login_ui.visible = true
	if main_ui:
		main_ui.visible = false

func hide_login_ui() -> void:
	if login_ui:
		login_ui.visible = false
	if main_ui:
		main_ui.visible = true

func _on_connected() -> void:
	# Servidor solicitará autenticação
	show_login_ui()

func _on_disconnected() -> void:
	is_authenticated = false
	show_login_ui()
	if login_ui and login_ui.has_method("show_message"):
		login_ui.show_message("Desconectado do servidor", true)

func _on_authentication_required() -> void:
	show_login_ui()

func _on_authentication_success(character_data: Dictionary) -> void:
	is_authenticated = true
	hide_login_ui()
	if login_ui and login_ui.has_method("clear_fields"):
		login_ui.clear_fields()
	print("Autenticação bem-sucedida! Bem-vindo, ", character_data.get("name", "Jogador"))

func _on_authentication_failed(reason: String) -> void:
	is_authenticated = false
	show_login_ui()
	if login_ui and login_ui.has_method("show_message"):
		login_ui.show_message(reason, true)

func _on_login_requested(username: String, password: String) -> void:
	if connection_client and connection_client.has_method("send_login"):
		connection_client.send_login(username, password)

func _on_register_requested(username: String, email: String, password: String) -> void:
	if connection_client and connection_client.has_method("send_register"):
		connection_client.send_register(username, email, password)


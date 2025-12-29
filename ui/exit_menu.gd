extends Control
class_name ExitMenu

## Menu de saída do jogo (sem pausa - jogo online)

signal exit_game

const ConnectionBase = preload("res://shared/classes/connection_base.gd")

@onready var exit_button: Button = $Panel/VBoxContainer/ExitButton

var is_visible: bool = false

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if exit_button:
		exit_button.pressed.connect(_on_exit_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("menu"):
		toggle_menu()

func toggle_menu() -> void:
	if ConnectionBase.is_server():
		return  # Servidor não precisa de menu
	
	is_visible = not is_visible
	visible = is_visible
	
	if is_visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if exit_button:
			exit_button.grab_focus()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_exit_pressed() -> void:
	exit_game.emit()
	quit_game()

func quit_game() -> void:
	# Desconectar do servidor se estiver conectado
	if ConnectionBase.is_peer_connected:
		# Tentar desconectar via ConnectionClient se disponível
		var connection_client = get_node_or_null("/root/MainClient/ConnectionClient")
		if connection_client and connection_client.has_method("disconnect_all"):
			connection_client.disconnect_all()
		# Fallback para Connection antigo (se ainda existir)
		var connection = get_node_or_null("/root/Main/Connection")
		if connection and connection.has_method("disconnect_all"):
			connection.disconnect_all()
	
	# Salvar dados se necessário
	# (implementar salvamento aqui se necessário)
	
	# Sair do jogo
	get_tree().quit()


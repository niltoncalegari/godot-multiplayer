extends Control
class_name LoginUI

## UI de login e registro

signal login_requested(username: String, password: String)
signal register_requested(username: String, email: String, password: String)

@onready var login_panel: Panel = $LoginPanel
@onready var register_panel: Panel = $RegisterPanel
@onready var message_label: Label = $MessageLabel

# Login
@onready var login_username: LineEdit = $LoginPanel/VBoxContainer/UsernameEdit
@onready var login_password: LineEdit = $LoginPanel/VBoxContainer/PasswordEdit
@onready var login_button: Button = $LoginPanel/VBoxContainer/LoginButton
@onready var show_register_button: Button = $LoginPanel/VBoxContainer/ShowRegisterButton

# Register
@onready var register_username: LineEdit = $RegisterPanel/VBoxContainer/UsernameEdit
@onready var register_email: LineEdit = $RegisterPanel/VBoxContainer/EmailEdit
@onready var register_password: LineEdit = $RegisterPanel/VBoxContainer/PasswordEdit
@onready var register_confirm_password: LineEdit = $RegisterPanel/VBoxContainer/ConfirmPasswordEdit
@onready var register_button: Button = $RegisterPanel/VBoxContainer/RegisterButton
@onready var show_login_button: Button = $RegisterPanel/VBoxContainer/ShowLoginButton

func _ready() -> void:
	show_login()
	
	if login_button:
		login_button.pressed.connect(_on_login_pressed)
	if register_button:
		register_button.pressed.connect(_on_register_pressed)
	if show_register_button:
		show_register_button.pressed.connect(show_register)
	if show_login_button:
		show_login_button.pressed.connect(show_login)
	
	# Enter para enviar
	if login_username:
		login_username.text_submitted.connect(func(_text): _on_login_pressed())
	if login_password:
		login_password.text_submitted.connect(func(_text): _on_login_pressed())
	if register_password:
		register_password.text_submitted.connect(func(_text): _on_register_pressed())
	if register_confirm_password:
		register_confirm_password.text_submitted.connect(func(_text): _on_register_pressed())

func show_login() -> void:
	if login_panel:
		login_panel.visible = true
	if register_panel:
		register_panel.visible = false
	if login_username:
		login_username.grab_focus()

func show_register() -> void:
	if login_panel:
		login_panel.visible = false
	if register_panel:
		register_panel.visible = true
	if register_username:
		register_username.grab_focus()

func _on_login_pressed() -> void:
	if not login_username or not login_password:
		return
	
	var username = login_username.text.strip_edges()
	var password = login_password.text
	
	if username.is_empty():
		show_message("Digite o username", true)
		return
	
	if password.is_empty():
		show_message("Digite a senha", true)
		return
	
	login_requested.emit(username, password)

func _on_register_pressed() -> void:
	if not register_username or not register_email or not register_password or not register_confirm_password:
		return
	
	var username = register_username.text.strip_edges()
	var email = register_email.text.strip_edges()
	var password = register_password.text
	var confirm_password = register_confirm_password.text
	
	# Validações
	if username.is_empty():
		show_message("Digite o username", true)
		return
	
	if username.length() < 3:
		show_message("Username deve ter pelo menos 3 caracteres", true)
		return
	
	if email.is_empty():
		show_message("Digite o email", true)
		return
	
	if not email.contains("@"):
		show_message("Email inválido", true)
		return
	
	if password.is_empty():
		show_message("Digite a senha", true)
		return
	
	if password.length() < 6:
		show_message("Senha deve ter pelo menos 6 caracteres", true)
		return
	
	if password != confirm_password:
		show_message("Senhas não coincidem", true)
		return
	
	register_requested.emit(username, email, password)

func show_message(text: String, is_error: bool = false) -> void:
	if message_label:
		message_label.text = text
		if is_error:
			message_label.modulate = Color.RED
		else:
			message_label.modulate = Color.WHITE
		
		# Limpar mensagem após 3 segundos
		if not message_label.get_tree().create_timer(3.0).timeout.is_connected(_clear_message):
			message_label.get_tree().create_timer(3.0).timeout.connect(_clear_message)

func _clear_message() -> void:
	if message_label:
		message_label.text = ""

func clear_fields() -> void:
	if login_username:
		login_username.text = ""
	if login_password:
		login_password.text = ""
	if register_username:
		register_username.text = ""
	if register_email:
		register_email.text = ""
	if register_password:
		register_password.text = ""
	if register_confirm_password:
		register_confirm_password.text = ""


extends Node
class_name ConnectionBase

## Classe base para conexão compartilhada entre cliente e servidor

signal connected
signal disconnected

static var is_peer_connected: bool = false

@export var port: int = 5050
@export var max_clients: int = 32
@export var host: String = "localhost"
@export var use_localhost_in_editor: bool = true

## Verifica se está rodando como servidor
static func is_server() -> bool:
	return "--server" in OS.get_cmdline_args()


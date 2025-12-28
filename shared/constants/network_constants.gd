extends RefCounted
class_name NetworkConstants

## Constantes de rede compartilhadas entre cliente e servidor

# Protocolo
const PROTOCOL_VERSION: int = 1

# Timeouts
const CONNECTION_TIMEOUT: float = 10.0
const PING_INTERVAL: float = 1.0

# Limites
const MAX_MESSAGE_SIZE: int = 65536
const MAX_RPC_CALLS_PER_SECOND: int = 60

# Códigos de erro
enum NetworkError {
	SUCCESS = 0,
	CONNECTION_FAILED = 1,
	TIMEOUT = 2,
	INVALID_DATA = 3,
	AUTHENTICATION_FAILED = 4,
	VERSION_MISMATCH = 5
}


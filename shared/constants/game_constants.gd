extends RefCounted
class_name GameConstants

## Constantes do jogo compartilhadas entre cliente e servidor

# Configurações de rede
const DEFAULT_PORT: int = 5050
const MAX_CLIENTS: int = 32
const DEFAULT_HOST: String = "localhost"

# Configurações de jogo
const MAX_LEVEL: int = 400
const MIN_LEVEL: int = 1
const BASE_EXPERIENCE: int = 100

# Atributos
const MIN_ATTRIBUTE_VALUE: int = 0
const MAX_ATTRIBUTE_VALUE: int = 32767
const BASE_ATTRIBUTE_POINTS: int = 5

# Inventário
const MAX_INVENTORY_SLOTS: int = 60
const MAX_EQUIPMENT_SLOTS: int = 10

# Combate
const BASE_ATTACK_SPEED: float = 1.0
const BASE_MOVE_SPEED: float = 8.0


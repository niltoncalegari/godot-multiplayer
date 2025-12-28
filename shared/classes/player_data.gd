extends RefCounted
class_name PlayerData

## Estrutura de dados do player compartilhada entre cliente e servidor

var id: int = 0
var username: String = ""
var character_name: String = ""
var class_type: CharacterClass.ClassType = CharacterClass.ClassType.WARRIOR

# Atributos
var level: int = 1
var experience: int = 0
var experience_to_next_level: int = 100

# Atributos base
var strength: int = 0      # STR
var agility: int = 0       # AGI
var vitality: int = 0      # VIT
var intelligence: int = 0  # INT
var command: int = 0       # CMD

# Pontos disponíveis para distribuir
var available_points: int = 0

# Posição
var position: Vector3 = Vector3.ZERO
var rotation: Vector3 = Vector3.ZERO

# Status
var health: float = 100.0
var max_health: float = 100.0
var mana: float = 50.0
var max_mana: float = 50.0

## Calcula os stats derivados baseados nos atributos
func calculate_derived_stats() -> void:
	# Exemplo: HP baseado em VIT
	max_health = 100.0 + (vitality * 10.0)
	health = min(health, max_health)
	
	# Exemplo: Mana baseado em INT
	max_mana = 50.0 + (intelligence * 5.0)
	mana = min(mana, max_mana)

## Serializa os dados para envio via rede
func to_dict() -> Dictionary:
	return {
		"id": id,
		"username": username,
		"character_name": character_name,
		"class_type": class_type,
		"level": level,
		"experience": experience,
		"experience_to_next_level": experience_to_next_level,
		"strength": strength,
		"agility": agility,
		"vitality": vitality,
		"intelligence": intelligence,
		"command": command,
		"available_points": available_points,
		"position": {"x": position.x, "y": position.y, "z": position.z},
		"rotation": {"x": rotation.x, "y": rotation.y, "z": rotation.z},
		"health": health,
		"max_health": max_health,
		"mana": mana,
		"max_mana": max_mana
	}

## Deserializa os dados recebidos via rede
func from_dict(data: Dictionary) -> void:
	id = data.get("id", 0)
	username = data.get("username", "")
	character_name = data.get("character_name", "")
	class_type = data.get("class_type", CharacterClass.ClassType.WARRIOR)
	level = data.get("level", 1)
	experience = data.get("experience", 0)
	experience_to_next_level = data.get("experience_to_next_level", 100)
	strength = data.get("strength", 0)
	agility = data.get("agility", 0)
	vitality = data.get("vitality", 0)
	intelligence = data.get("intelligence", 0)
	command = data.get("command", 0)
	available_points = data.get("available_points", 0)
	
	var pos_data = data.get("position", {})
	position = Vector3(pos_data.get("x", 0), pos_data.get("y", 0), pos_data.get("z", 0))
	
	var rot_data = data.get("rotation", {})
	rotation = Vector3(rot_data.get("x", 0), rot_data.get("y", 0), rot_data.get("z", 0))
	
	health = data.get("health", 100.0)
	max_health = data.get("max_health", 100.0)
	mana = data.get("mana", 50.0)
	max_mana = data.get("max_mana", 50.0)
	
	calculate_derived_stats()


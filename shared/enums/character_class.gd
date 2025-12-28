extends RefCounted
class_name CharacterClass

## Enum de classes de personagem

enum ClassType {
	WARRIOR = 0,    # Guerreiro
	WIZARD = 1,     # Mago
	ARCHER = 2,     # Arqueiro
	ELF = 3         # Elfo
}

## Retorna o nome da classe
static func get_class_name(class_type: ClassType) -> String:
	match class_type:
		ClassType.WARRIOR:
			return "Guerreiro"
		ClassType.WIZARD:
			return "Mago"
		ClassType.ARCHER:
			return "Arqueiro"
		ClassType.ELF:
			return "Elfo"
		_:
			return "Desconhecido"

## Retorna a descrição da classe
static func get_class_description(class_type: ClassType) -> String:
	match class_type:
		ClassType.WARRIOR:
			return "Foco em força e resistência. Combate corpo a corpo."
		ClassType.WIZARD:
			return "Foco em inteligência e magia. Combate à distância."
		ClassType.ARCHER:
			return "Foco em agilidade e precisão. Combate à distância com arco."
		ClassType.ELF:
			return "Foco em suporte e versatilidade. Buffs e debuffs."
		_:
			return ""


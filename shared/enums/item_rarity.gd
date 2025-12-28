extends RefCounted
class_name ItemRarity

## Enum de raridade de itens

enum RarityType {
	COMMON = 0,      # Comum (Branco)
	UNCOMMON = 1,    # Incomum (Verde)
	RARE = 2,        # Raro (Azul)
	EPIC = 3,        # Épico (Roxo)
	LEGENDARY = 4,   # Lendário (Laranja)
	MYTHIC = 5       # Mítico (Vermelho)
}

## Retorna o nome da raridade
static func get_rarity_name(rarity: RarityType) -> String:
	match rarity:
		RarityType.COMMON:
			return "Comum"
		RarityType.UNCOMMON:
			return "Incomum"
		RarityType.RARE:
			return "Raro"
		RarityType.EPIC:
			return "Épico"
		RarityType.LEGENDARY:
			return "Lendário"
		RarityType.MYTHIC:
			return "Mítico"
		_:
			return "Desconhecido"

## Retorna a cor da raridade (para UI)
static func get_rarity_color(rarity: RarityType) -> Color:
	match rarity:
		RarityType.COMMON:
			return Color.WHITE
		RarityType.UNCOMMON:
			return Color.GREEN
		RarityType.RARE:
			return Color.CYAN
		RarityType.EPIC:
			return Color.MAGENTA
		RarityType.LEGENDARY:
			return Color.ORANGE
		RarityType.MYTHIC:
			return Color.RED
		_:
			return Color.GRAY


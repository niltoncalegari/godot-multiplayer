extends Node
class_name CharacterManager

## Gerenciador de personagens no servidor

signal character_loaded(peer_id: int, character_data: Dictionary)
signal character_saved(peer_id: int)

@export var database_manager: DatabaseManager
@export var auth_manager: AuthManager

## Carrega dados do personagem
func load_character(user_id: int, peer_id: int) -> void:
	if not database_manager or not database_manager.is_initialized:
		push_error("DatabaseManager não inicializado")
		return
	
	var query = "SELECT * FROM characters WHERE user_id = ? LIMIT 1"
	var error = database_manager.db.query_with_args(query, [user_id])
	
	if error == OK and database_manager.db.fetch_row():
		var character_data = {}
		for i in range(database_manager.db.get_column_count()):
			var column_name = database_manager.db.get_column_name(i)
			character_data[column_name] = database_manager.db.get_column_value(i)
		character_loaded.emit(peer_id, character_data)
	else:
		# Criar personagem padrão
		var default_character = create_default_character(user_id)
		character_loaded.emit(peer_id, default_character)

## Salva dados do personagem
func save_character(peer_id: int, character_data: PlayerData) -> void:
	if not database_manager or not database_manager.is_initialized:
		push_error("DatabaseManager não inicializado")
		return
	
	if not auth_manager.is_authenticated(peer_id):
		push_error("Peer não autenticado")
		return
	
	var user_id = auth_manager.get_user_id(peer_id)
	
	# Atualizar personagem no banco (usar prepared statement)
	var update_query = """
		UPDATE characters SET
			name = ?,
			class_type = ?,
			level = ?,
			experience = ?,
			experience_to_next_level = ?,
			strength = ?,
			agility = ?,
			vitality = ?,
			intelligence = ?,
			command = ?,
			available_points = ?,
			position_x = ?,
			position_y = ?,
			position_z = ?,
			rotation_x = ?,
			rotation_y = ?,
			rotation_z = ?,
			health = ?,
			max_health = ?,
			mana = ?,
			max_mana = ?,
			last_played = CURRENT_TIMESTAMP
		WHERE user_id = ?
	"""
	
	var args = [
		character_data.character_name,
		character_data.class_type,
		character_data.level,
		character_data.experience,
		character_data.experience_to_next_level,
		character_data.strength,
		character_data.agility,
		character_data.vitality,
		character_data.intelligence,
		character_data.command,
		character_data.available_points,
		character_data.position.x,
		character_data.position.y,
		character_data.position.z,
		character_data.rotation.x,
		character_data.rotation.y,
		character_data.rotation.z,
		character_data.health,
		character_data.max_health,
		character_data.mana,
		character_data.max_mana,
		user_id
	]
	
	var error = database_manager.db.query_with_args(update_query, args)
	if error == OK:
		character_saved.emit(peer_id)
		print("Personagem salvo para user_id: ", user_id)
	else:
		push_error("Erro ao salvar personagem: " + str(error))

## Cria um personagem padrão
func create_default_character(user_id: int) -> Dictionary:
	var default_name = "Personagem_" + str(user_id)
	var insert_query = """
		INSERT INTO characters (
			user_id, name, class_type, level, experience, experience_to_next_level,
			strength, agility, vitality, intelligence, command, available_points,
			position_x, position_y, position_z,
			health, max_health, mana, max_mana
		)
		VALUES (?, ?, 0, 1, 0, 100, 0, 0, 0, 0, 0, 5, 0.0, 0.0, 0.0, 100.0, 100.0, 50.0, 50.0)
	"""
	
	var error = database_manager.db.query_with_args(insert_query, [user_id, default_name])
	if error == OK:
		var query = "SELECT * FROM characters WHERE user_id = ? LIMIT 1"
		database_manager.db.query_with_args(query, [user_id])
		if database_manager.db.fetch_row():
			var character_data = {}
			for i in range(database_manager.db.get_column_count()):
				var column_name = database_manager.db.get_column_name(i)
				character_data[column_name] = database_manager.db.get_column_value(i)
			return character_data
	
	return {}

## Salva posição do personagem (chamado periodicamente)
func save_character_position(peer_id: int, position: Vector3) -> void:
	if not auth_manager.is_authenticated(peer_id):
		return
	
	var user_id = auth_manager.get_user_id(peer_id)
	var query = "UPDATE characters SET position_x = ?, position_y = ?, position_z = ? WHERE user_id = ?"
	database_manager.db.query_with_args(query, [position.x, position.y, position.z, user_id])


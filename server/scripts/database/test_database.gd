extends Node
class_name TestDatabase

## Script de teste para verificar criação das tabelas do banco de dados

const ConnectionBase = preload("res://shared/classes/connection_base.gd")

@export var database_manager: DatabaseManager

func _ready() -> void:
	if not ConnectionBase.is_server():
		return
	
	# Aguardar inicialização do banco
	if database_manager:
		if database_manager.is_initialized:
			test_tables()
		else:
			database_manager.database_initialized.connect(test_tables)

func test_tables() -> void:
	print("=== Teste de Tabelas do Banco de Dados ===")
	
	# Verificar se as tabelas existem
	var tables = ["users", "characters", "inventory", "equipment"]
	
	for table_name in tables:
		var query = "SELECT name FROM sqlite_master WHERE type='table' AND name='%s'" % table_name
		var result = database_manager.execute_query_with_result(query)
		
		if result.size() > 0:
			print("✅ Tabela '%s' existe" % table_name)
			
			# Contar registros
			var count_query = "SELECT COUNT(*) as count FROM %s" % table_name
			var count_result = database_manager.execute_query_with_result(count_query)
			if count_result.size() > 0:
				print("   Registros: %d" % count_result[0].get("count", 0))
		else:
			print("❌ Tabela '%s' NÃO existe" % table_name)
	
	# Verificar índices
	print("\n=== Verificando Índices ===")
	var index_query = "SELECT name FROM sqlite_master WHERE type='index' AND name LIKE 'idx_%'"
	var indexes = database_manager.execute_query_with_result(index_query)
	
	for index in indexes:
		print("✅ Índice: %s" % index.get("name", ""))
	
	# Verificar configurações do SQLite
	print("\n=== Configurações do SQLite ===")
	var pragma_queries = [
		["journal_mode", "PRAGMA journal_mode"],
		["foreign_keys", "PRAGMA foreign_keys"],
		["cache_size", "PRAGMA cache_size"]
	]
	
	for pragma_info in pragma_queries:
		var result = database_manager.execute_query_with_result(pragma_info[1])
		if result.size() > 0:
			var value = result[0].values()[0] if result[0].size() > 0 else "N/A"
			print("   %s: %s" % [pragma_info[0], value])
	
	print("\n=== Teste Concluído ===")
	print("Banco de dados em: %s" % database_manager.database_path)


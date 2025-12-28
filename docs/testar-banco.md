# Como Testar o Banco de Dados

## Pré-requisitos

1. ✅ Docker Compose rodando (volume criado)
2. ✅ Plugin SQLite instalado
3. ✅ Cena do servidor criada

## Passos para Testar

### 1. Iniciar Docker Compose

```bash
docker-compose up -d server-data
```

Verificar se está rodando:
```bash
docker-compose ps
```

### 2. Executar Servidor no Godot

1. Abra o projeto no Godot
2. Configure a cena principal do servidor:
   - Project > Project Settings > Application > Run > Main Scene
   - Defina como `res://server/scenes/main_server.tscn`
3. Execute o servidor com `--server`:
   - No terminal: `godot --headless --server`
   - Ou configure no editor para executar com argumentos

### 3. Verificar Logs

O servidor deve mostrar:
- "Banco de dados SQLite inicializado com sucesso em: [caminho]"
- "SQLite configurado: cache_size=10000KB, journal_mode=WAL"
- "=== Teste de Tabelas do Banco de Dados ==="
- ✅ Tabela 'users' existe
- ✅ Tabela 'characters' existe
- ✅ Tabela 'inventory' existe
- ✅ Tabela 'equipment' existe

### 4. Verificar Arquivo do Banco

O banco será criado em:
- **Desenvolvimento**: `user://game_database.db`
- **Docker/Produção**: `/app/server_data/game_database.db`

Para verificar no Docker:
```bash
docker exec -it godot-multiplayer-data ls -lh /app/server_data/
```

## Tabelas Criadas

### users
- id (PRIMARY KEY)
- username (UNIQUE)
- email (UNIQUE)
- password_hash
- salt
- created_at
- last_login

### characters
- id (PRIMARY KEY)
- user_id (FOREIGN KEY)
- name
- class_type
- level, experience
- strength, agility, vitality, intelligence, command
- available_points
- position_x, position_y, position_z
- rotation_x, rotation_y, rotation_z
- health, max_health, mana, max_mana
- created_at, last_played

### inventory
- id (PRIMARY KEY)
- character_id (FOREIGN KEY)
- item_id
- slot
- quantity

### equipment
- id (PRIMARY KEY)
- character_id (FOREIGN KEY)
- slot_type
- item_id
- UNIQUE(character_id, slot_type)

## Índices Criados

- idx_users_username
- idx_users_email
- idx_characters_user_id
- idx_characters_name
- idx_inventory_character_id
- idx_equipment_character_id

## Troubleshooting

### Plugin SQLite não carrega
- Verificar se o plugin está instalado
- Recarregar o projeto
- Verificar logs do Godot

### Tabelas não são criadas
- Verificar se DatabaseManager está inicializado
- Verificar logs de erro
- Verificar permissões do diretório

### Erro ao abrir banco
- Verificar se o diretório existe
- Verificar permissões
- Verificar se o caminho está correto


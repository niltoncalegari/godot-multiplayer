# Arquitetura Cliente/Servidor

## Visão Geral

O projeto será dividido em três partes principais:
1. **Shared**: Código compartilhado entre cliente e servidor
2. **Client**: Código específico do cliente
3. **Server**: Código específico do servidor

## Estrutura de Pastas Proposta

```
godot-multiplayer/
├── shared/                    # Código compartilhado
│   ├── classes/              # Classes compartilhadas
│   │   ├── player_data.gd    # Estrutura de dados do player
│   │   ├── item_data.gd      # Estrutura de dados de itens
│   │   └── character_class.gd # Definições de classes
│   ├── constants/            # Constantes compartilhadas
│   │   ├── game_constants.gd
│   │   └── network_constants.gd
│   └── enums/                # Enums compartilhados
│       ├── item_rarity.gd
│       └── character_class.gd
│
├── client/                    # Código do cliente
│   ├── scenes/               # Cenas do cliente
│   │   ├── main_client.tscn
│   │   └── ui/
│   ├── scripts/              # Scripts do cliente
│   │   ├── connection_client.gd
│   │   ├── ui/
│   │   ├── inventory/
│   │   └── character/
│   └── assets/               # Assets do cliente
│
├── server/                    # Código do servidor
│   ├── scenes/               # Cenas do servidor (headless)
│   │   └── main_server.tscn
│   ├── scripts/              # Scripts do servidor
│   │   ├── connection_server.gd
│   │   ├── database/
│   │   ├── authentication/
│   │   ├── game_logic/
│   │   └── combat/
│   └── config/                # Configurações do servidor
│       └── server_config.gd
│
├── assets/                    # Assets compartilhados
│   ├── models/
│   ├── textures/
│   ├── animations/
│   └── sounds/
│
└── docs/                      # Documentação
    ├── game-design.md
    ├── regras-projeto.md
    ├── features.md
    └── arquitetura.md
```

## Fluxo de Comunicação

### Conexão Inicial

```
Cliente                    Servidor
  |                          |
  |--- Conectar ------------>|
  |                          |--- Validar conexão
  |                          |--- Autenticar usuário
  |<-- Autenticação OK ------|
  |                          |
  |--- Solicitar personagem ->|
  |                          |--- Buscar no BD
  |<-- Dados do personagem ---|
  |                          |
  |--- Spawn request -------->|
  |                          |--- Criar player
  |<-- Player criado ---------|
```

### Durante o Jogo

```
Cliente                    Servidor
  |                          |
  |--- Input (movimento) ---->|
  |                          |--- Validar input
  |                          |--- Atualizar estado
  |<-- Estado atualizado -----|
  |                          |
  |--- Ação (ataque) -------->|
  |                          |--- Validar ação
  |                          |--- Processar combate
  |<-- Resultado do combate --|
```

## Sistema de Autoridade

### Servidor é Autoridade

- **Posição do Player**: Servidor valida e corrige
- **Combate**: Servidor calcula dano e resultados
- **Inventário**: Servidor gerencia itens
- **Atributos**: Servidor valida mudanças

### Cliente Prediz

- **Movimento**: Cliente prediz movimento para responsividade
- **Animações**: Cliente executa animações localmente
- **UI**: Cliente gerencia interface

## Sistema de Banco de Dados

### Estrutura Proposta

```sql
-- Tabela de Usuários
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Personagens
CREATE TABLE characters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    class_id INTEGER NOT NULL,
    level INTEGER DEFAULT 1,
    experience INTEGER DEFAULT 0,
    str INTEGER DEFAULT 0,
    agi INTEGER DEFAULT 0,
    vit INTEGER DEFAULT 0,
    int INTEGER DEFAULT 0,
    cmd INTEGER DEFAULT 0,
    points_available INTEGER DEFAULT 0,
    position_x REAL,
    position_y REAL,
    position_z REAL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tabela de Inventário
CREATE TABLE inventory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    character_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    slot INTEGER,
    quantity INTEGER DEFAULT 1,
    FOREIGN KEY (character_id) REFERENCES characters(id)
);

-- Tabela de Equipamentos
CREATE TABLE equipment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    character_id INTEGER NOT NULL,
    slot_type VARCHAR(20) NOT NULL, -- helmet, armor, weapon, etc.
    item_id INTEGER,
    FOREIGN KEY (character_id) REFERENCES characters(id)
);
```

### Camada de Acesso ao Banco

```gdscript
# server/scripts/database/database_manager.gd
class_name DatabaseManager
extends Node

# Singleton para gerenciar conexão com banco de dados
# Usar SQLite para desenvolvimento, PostgreSQL/MySQL para produção
```

## Sistema de Autenticação

### Fluxo de Autenticação

1. Cliente envia credenciais (username/password)
2. Servidor valida credenciais no banco
3. Servidor gera token de sessão (ou JWT)
4. Servidor retorna token para cliente
5. Cliente usa token em requisições subsequentes

### Segurança

- Senhas sempre hasheadas (bcrypt)
- Tokens com expiração
- Rate limiting em tentativas de login
- Validação de dados no servidor

## Sistema de Sincronização

### MultiplayerSynchronizer

- Usar para dados que precisam ser sincronizados em tempo real
- Exemplo: Posição, rotação, animações

### RPCs

- Usar para ações que precisam de validação
- Exemplo: Ataques, uso de itens, mudanças de equipamento

## Exportação

### Cliente

- **Main Scene**: `client/scenes/main_client.tscn`
- **Features**: Apenas código do cliente
- **Dependencies**: Shared code, assets

### Servidor

- **Main Scene**: `server/scenes/main_server.tscn`
- **Features**: Apenas código do servidor
- **Headless**: Sem interface gráfica
- **Dependencies**: Shared code, database

## Performance

### Otimizações do Servidor

- Processar apenas lógica do jogo
- Sem renderização
- Pooling de objetos
- Cache de dados frequentes

### Otimizações do Cliente

- LOD para modelos
- Occlusion culling
- Compressão de dados de rede
- Interpolação para movimento suave

## Escalabilidade

### Futuro

- Múltiplos servidores (sharding)
- Load balancing
- Database replication
- Cache distribuído (Redis)

## Notas de Implementação

### Migração do Código Atual

1. Identificar código compartilhado
2. Mover para `shared/`
3. Separar código cliente/servidor
4. Criar cenas separadas
5. Configurar exportação

### Compatibilidade

- Manter sistema de VoIP funcionando
- Manter sistema de movimentação
- Migrar gradualmente


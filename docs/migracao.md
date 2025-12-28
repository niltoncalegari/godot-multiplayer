# Guia de Migração

Este guia ajuda a migrar o código existente para a nova estrutura de pastas (shared/client/server).

## Estrutura Atual vs Nova

### Estrutura Atual
```
godot-multiplayer/
├── main/
│   ├── connection.gd
│   ├── player_spawner.gd
│   └── main.tscn
├── player/
├── ui/
├── user_data/
└── voip/
```

### Nova Estrutura
```
godot-multiplayer/
├── shared/          # Código compartilhado
├── client/          # Código do cliente
├── server/          # Código do servidor
└── assets/          # Assets
```

## Plano de Migração

### Fase 1: Identificar Código Compartilhado

#### Código que deve ir para `shared/`:
- Classes de dados (PlayerData, ItemData, etc.)
- Constantes do jogo
- Enums
- Estruturas de dados compartilhadas

#### Código que deve ir para `client/`:
- UI (toda a pasta `ui/`)
- Sistema de câmera
- Sistema de VoIP (cliente)
- Input handling
- Renderização

#### Código que deve ir para `server/`:
- Lógica de validação
- Sistema de spawn (autoridade)
- Sistema de combate (cálculos)
- Banco de dados
- Autenticação

### Fase 2: Migrar Código Compartilhado

1. **Mover constantes**:
   - Criar `shared/constants/game_constants.gd`
   - Mover constantes de `main/connection.gd` se aplicável

2. **Mover classes de dados**:
   - Criar `shared/classes/player_data.gd`
   - Migrar estruturas de `user_data/`

3. **Mover enums**:
   - Criar `shared/enums/`
   - Definir enums compartilhados

### Fase 3: Separar Cliente e Servidor

#### Connection.gd

**Atual**: `main/connection.gd` tem lógica de cliente e servidor misturada

**Novo**:
- `shared/classes/connection_base.gd`: Código compartilhado
- `client/scripts/connection_client.gd`: Lógica do cliente
- `server/scripts/connection_server.gd`: Lógica do servidor

#### Player Spawner

**Atual**: `main/player_spawner.gd` funciona para ambos

**Novo**:
- `server/scripts/player_spawner.gd`: Autoridade do servidor
- `client/scripts/player_manager.gd`: Gerenciamento local do cliente

#### Main Scene

**Atual**: `main/main.tscn` funciona para ambos

**Novo**:
- `client/scenes/main_client.tscn`: Cena do cliente
- `server/scenes/main_server.tscn`: Cena do servidor (headless)

### Fase 4: Migrar Assets

1. **Mover assets para `assets/`**:
   - `player/model/` → `assets/models/characters/`
   - `levels/` → `assets/levels/` (ou manter em `levels/` se for específico)
   - Sons, texturas, etc.

### Fase 5: Atualizar Referências

1. **Atualizar paths no project.godot**
2. **Atualizar imports nos scripts**
3. **Atualizar referências em cenas**

## Exemplos de Migração

### Exemplo 1: Connection.gd

**Antes** (`main/connection.gd`):
```gdscript
extends Node
class_name Connection

func _ready() -> void:
	if Connection.is_server(): start_server()
	else: start_client()
```

**Depois**:

`shared/classes/connection_base.gd`:
```gdscript
extends Node
class_name ConnectionBase

signal connected
signal disconnected

static func is_server() -> bool:
	return "--server" in OS.get_cmdline_args()
```

`client/scripts/connection_client.gd`:
```gdscript
extends ConnectionBase
class_name ConnectionClient

func _ready() -> void:
	if not ConnectionBase.is_server():
		start_client()
```

`server/scripts/connection_server.gd`:
```gdscript
extends ConnectionBase
class_name ConnectionServer

func _ready() -> void:
	if ConnectionBase.is_server():
		start_server()
```

### Exemplo 2: Player Data

**Antes**: Dados espalhados em vários lugares

**Depois**: `shared/classes/player_data.gd` (já criado)

## Checklist de Migração

### Preparação
- [ ] Backup do projeto atual
- [ ] Criar estrutura de pastas nova
- [ ] Criar arquivos base (constants, enums, etc.)

### Migração de Código
- [ ] Migrar código compartilhado para `shared/`
- [ ] Separar lógica cliente em `client/`
- [ ] Separar lógica servidor em `server/`
- [ ] Criar cenas separadas para cliente e servidor

### Migração de Assets
- [ ] Organizar assets em `assets/`
- [ ] Atualizar referências de paths

### Testes
- [ ] Testar cliente conectando ao servidor
- [ ] Testar servidor iniciando corretamente
- [ ] Testar funcionalidades existentes

### Limpeza
- [ ] Remover código antigo não utilizado
- [ ] Atualizar documentação
- [ ] Atualizar README.md

## Notas Importantes

1. **Migração Gradual**: Não precisa migrar tudo de uma vez. Pode ser feito incrementalmente.

2. **Manter Funcionalidade**: Durante a migração, manter o código funcionando. Migrar feature por feature.

3. **Testes Contínuos**: Testar após cada migração para garantir que nada quebrou.

4. **Versionamento**: Fazer commits frequentes durante a migração para poder reverter se necessário.

## Próximos Passos

Após a migração básica:
1. Implementar sistema de banco de dados
2. Implementar sistema de autenticação
3. Começar a implementar features do GDD


# Docker Setup

## Visão Geral

O projeto usa SQLite em Docker para facilitar deploy e gerenciamento. SQLite é perfeito para este projeto porque:
- ✅ Gratuito (sem custos de licença)
- ✅ Simples (arquivo único)
- ✅ Rápido (excelente performance)
- ✅ Fácil backup (copiar arquivo)
- ✅ Funciona perfeitamente em Docker

## Início Rápido

### 1. Iniciar Volume de Dados

```bash
docker-compose up -d server-data
```

Isso cria um volume persistente para o banco SQLite.

### 2. Executar Servidor

**Desenvolvimento (local):**
```bash
# O servidor criará o banco em user://game_database.db
godot --headless --server
```

**Produção (Docker):**
```bash
# Descomente a seção game-server no docker-compose.yml
# Depois execute:
docker-compose up -d
```

## Estrutura

```
docker-compose.yml          # Configuração Docker
server_data/                # Volume com banco SQLite (criado automaticamente)
  └── game_database.db      # Banco de dados SQLite
```

## Backup

### Backup Automático

O sistema tem backup automático configurado (ver `database_backup.gd`):
- Intervalo: 6 horas
- Local: `user://backups/` ou `/app/server_data/backups/`
- Retenção: 10 backups mais recentes

### Backup Manual

```bash
# Copiar arquivo do banco
docker cp godot-multiplayer-data:/app/server_data/game_database.db ./backup.db
```

## Volumes

O Docker Compose cria um volume nomeado `server_data` que persiste os dados mesmo se o container for removido.

### Verificar Volume

```bash
docker volume ls
docker volume inspect godot-multiplayer_server_data
```

### Remover Volume (CUIDADO - apaga dados!)

```bash
docker-compose down -v
```

## Troubleshooting

### Volume não cria
```bash
docker-compose down
docker-compose up -d server-data
```

### Permissões
```bash
# Se houver problemas de permissão
docker exec -it godot-multiplayer-data chmod 777 /app/server_data
```

### Ver logs
```bash
docker-compose logs -f
```

## Migração para Cluster (Futuro)

Quando precisar de múltiplos servidores, você pode:

1. **Manter SQLite**: Usar replicação de arquivos
2. **Migrar para PostgreSQL**: Script de migração disponível
3. **Híbrido**: SQLite local + PostgreSQL central

Veja `docs/docker-sqlite.md` para mais detalhes.


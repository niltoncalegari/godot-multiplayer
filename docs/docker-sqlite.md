# Docker com SQLite

## Visão Geral

O projeto usa SQLite como banco de dados, que é:
- ✅ **Gratuito** - Sem custos de licença
- ✅ **Simples** - Arquivo único, fácil de gerenciar
- ✅ **Rápido** - Excelente performance para jogos
- ✅ **Portável** - Fácil backup e migração
- ✅ **Docker-friendly** - Funciona perfeitamente em containers

## Por que SQLite?

### Vantagens
1. **Custo Zero**: Não precisa de servidor de banco separado
2. **Simplicidade**: Um único arquivo, fácil de fazer backup
3. **Performance**: Excelente para jogos (leitura rápida)
4. **Escalabilidade**: Pode migrar para PostgreSQL depois se necessário
5. **Docker**: Volume simples, sem necessidade de container separado

### Quando Migrar para PostgreSQL?
- Quando precisar de múltiplos servidores de jogo (cluster)
- Quando o banco crescer muito (>100GB)
- Quando precisar de replicação em tempo real
- Quando precisar de queries complexas distribuídas

## Configuração Docker

### Estrutura

O Docker Compose cria um volume para persistir os dados do SQLite:

```yaml
volumes:
  server_data:
    driver: local
```

O banco SQLite será criado em `/app/server_data/game_database.db` quando o servidor iniciar.

### Uso

1. **Iniciar volume de dados**:
```bash
docker-compose up -d server-data
```

2. **Executar servidor localmente** (desenvolvimento):
```bash
# O servidor criará o banco em user://game_database.db
```

3. **Executar servidor no Docker** (produção):
```bash
# Descomente a seção game-server no docker-compose.yml
docker-compose up -d
```

## Backup do SQLite

### Backup Automático

O sistema tem backup automático configurado:
- Intervalo: 6 horas (configurável)
- Local: `user://backups/` ou `/app/server_data/backups/`
- Retenção: 10 backups mais recentes

### Backup Manual

```gdscript
# No servidor
database_backup.create_manual_backup()
```

### Backup via Docker

```bash
# Copiar arquivo do banco
docker cp godot-multiplayer-data:/app/server_data/game_database.db ./backup.db

# Ou copiar todo o volume
docker run --rm -v godot-multiplayer_server_data:/data -v $(pwd):/backup alpine tar czf /backup/db-backup.tar.gz /data
```

## Migração para Cluster (Futuro)

Quando precisar de múltiplos servidores:

### Opção 1: Replicação SQLite
- Usar WAL (Write-Ahead Logging) - já configurado
- Sincronizar arquivos WAL entre servidores
- Mais complexo, mas mantém SQLite

### Opção 2: Migrar para PostgreSQL
- Criar script de migração
- Converter dados do SQLite para PostgreSQL
- Atualizar DatabaseManager

### Opção 3: Híbrido
- SQLite para dados locais/cache
- PostgreSQL para dados compartilhados
- Sincronização periódica

## Performance

SQLite é otimizado para:
- ✅ Leitura rápida (cache configurado)
- ✅ Escrita eficiente (WAL mode)
- ✅ Operações simples (INSERT, UPDATE, SELECT)
- ✅ Até ~100GB de dados

Para jogos MMORPG, SQLite é suficiente até:
- ~10.000 jogadores simultâneos
- ~1 milhão de personagens
- ~100GB de dados

## Monitoramento

### Tamanho do Banco
```bash
# Ver tamanho do arquivo
ls -lh game_database.db
```

### Integridade
```bash
# Verificar integridade do banco
sqlite3 game_database.db "PRAGMA integrity_check;"
```

### Estatísticas
```sql
-- Ver tamanho das tabelas
SELECT name, (SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name=m.name) as row_count
FROM sqlite_master m
WHERE type='table';
```

## Troubleshooting

### Banco não cria
- Verificar permissões do diretório
- Verificar se plugin SQLite está instalado
- Verificar logs do servidor

### Performance lenta
- Aumentar `CACHE_SIZE` em `database_config.gd`
- Verificar índices nas tabelas
- Considerar VACUUM periódico

### Backup falha
- Verificar espaço em disco
- Verificar permissões de escrita
- Verificar se banco está fechado durante backup

## Referências

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [SQLite Performance](https://www.sqlite.org/performance.html)
- [Docker Volumes](https://docs.docker.com/storage/volumes/)


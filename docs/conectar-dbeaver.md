# Conectar ao Banco SQLite com DBeaver

## Localização do Banco de Dados

O banco SQLite é criado automaticamente quando o servidor inicia. A localização depende do ambiente:

### Desenvolvimento (Local)
**Caminho**: `user://game_database.db`

No macOS, isso geralmente fica em:
```
~/Library/Application Support/Godot/app_userdata/[nome_do_projeto]/game_database.db
```

Para encontrar o caminho exato:
1. Execute o servidor uma vez
2. O caminho completo será mostrado no console: "Banco de dados SQLite inicializado com sucesso em: [caminho]"

### Docker/Produção
**Caminho no container**: `/app/server_data/game_database.db`

Para acessar do host:
```bash
# Copiar do container para o host
docker cp godot-multiplayer-data:/app/server_data/game_database.db ./game_database.db
```

Ou montar o volume localmente (ver abaixo).

## Conectar no DBeaver

### Opção 1: Arquivo Local (Desenvolvimento)

1. **Abrir DBeaver**
2. **Criar Nova Conexão**:
   - Clique em "Nova Conexão" (ícone de plug)
   - Selecione "SQLite"
   - Clique em "Next"

3. **Configurar Conexão**:
   - **Path**: Navegue até o arquivo `game_database.db`
   - Ou cole o caminho completo do arquivo
   - Clique em "Test Connection"
   - Se funcionar, clique em "Finish"

### Opção 2: Via Docker Volume

#### Método A: Copiar arquivo do container

```bash
# Copiar do container para local
docker cp godot-multiplayer-data:/app/server_data/game_database.db ./game_database.db

# Depois conectar no DBeaver usando o arquivo local
```

#### Método B: Montar volume localmente

1. **Encontrar o volume do Docker**:
```bash
docker volume inspect godot-multiplayer_server_data
```

2. **Localizar o mountpoint** (no macOS, geralmente em `/var/lib/docker/volumes/`)

3. **Criar symlink ou copiar**:
```bash
# No macOS, volumes ficam em um caminho específico
# Você pode copiar o arquivo ou criar um symlink
```

#### Método C: Montar diretório local no docker-compose

Atualizar `docker-compose.yml` para montar um diretório local:

```yaml
volumes:
  server_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ./server_data  # Diretório local
```

Depois:
```bash
docker-compose down
docker-compose up -d server-data
```

O banco ficará em `./server_data/game_database.db` (acessível diretamente).

## Verificar se o Banco Existe

### Desenvolvimento
```bash
# No terminal, encontrar o arquivo
find ~/Library/Application\ Support/Godot -name "game_database.db" 2>/dev/null
```

### Docker
```bash
# Verificar se o arquivo existe no container
docker exec -it godot-multiplayer-data ls -lh /app/server_data/

# Ver conteúdo do banco (se sqlite3 estiver disponível)
docker exec -it godot-multiplayer-data sh -c "if command -v sqlite3 >/dev/null 2>&1; then sqlite3 /app/server_data/game_database.db '.tables'; else echo 'sqlite3 não instalado'; fi"
```

## Dicas

1. **Primeiro execute o servidor** para criar o banco antes de conectar no DBeaver
2. **Use caminho absoluto** no DBeaver para evitar problemas
3. **Se o banco não existir**, execute o servidor uma vez para criá-lo
4. **Para desenvolvimento**, é mais fácil usar o caminho local (`user://`)
5. **Para produção**, considere montar o volume localmente no docker-compose

## Troubleshooting

### "Database file does not exist"
- Execute o servidor uma vez para criar o banco
- Verifique se o caminho está correto
- Verifique permissões do arquivo

### "Database is locked"
- Feche o servidor antes de abrir no DBeaver
- Ou use modo read-only no DBeaver

### Não encontra o arquivo
- Verifique os logs do servidor para ver o caminho exato
- Use `find` para localizar o arquivo
- Verifique se o servidor realmente criou o banco


# Guia de Build - Cliente e Servidor

Este guia explica como fazer o build do projeto para gerar executáveis separados do cliente e servidor.

## Pré-requisitos

1. **Godot Engine 4.5+** instalado
2. **Export Templates** instalados para as plataformas desejadas
3. **Arquivos de configuração** criados (`server_config.json` e `client_config.json`)

## Configuração dos Presets de Exportação

Antes de fazer o build, você precisa configurar os presets de exportação no Godot:

### 1. Abrir o Editor de Exportação

1. Abra o projeto no Godot
2. Vá em **Project → Export**
3. Clique em **Add...** para adicionar um novo preset

### 2. Configurar Preset do Cliente

1. Selecione a plataforma desejada (macOS, Windows, Linux)
2. Configure:
   - **Name**: `Client`
   - **Main Scene**: `res://client/scenes/main_client.tscn`
   - **Export Mode**: `Export all resources in the project`
   - **Export Path**: `builds/client/game_client.[extensão]`
   - **Features**: Remova `Server` se houver
   - **Options**:
     - ✅ **Export With Debug**: Desmarcado (para release)
     - ✅ **Embed PCK**: Marcado

3. Salve o preset

### 3. Configurar Preset do Servidor

1. Adicione outro preset para a mesma plataforma
2. Configure:
   - **Name**: `Server`
   - **Main Scene**: `res://server/scenes/main_server.tscn`
   - **Export Mode**: `Export all resources in the project`
   - **Export Path**: `builds/server/game_server.[extensão]`
   - **Features**: Adicione `Server` se necessário
   - **Options**:
     - ✅ **Export With Debug**: Desmarcado (para release)
     - ✅ **Embed PCK**: Marcado
     - ✅ **Run in Headless Mode**: Marcado (importante!)

3. Salve o preset

### 4. Configurações Adicionais do Servidor

No preset do servidor, você pode:
- Remover assets desnecessários (texturas, modelos, etc.) para reduzir o tamanho
- Adicionar a feature `Server` para excluir código do cliente

## Build Manual

### Via Editor do Godot

1. Abra **Project → Export**
2. Selecione o preset desejado (Client ou Server)
3. Clique em **Export Project**
4. Escolha o diretório de destino
5. Repita para o outro preset

### Via Linha de Comando

```bash
# Build do cliente
godot --headless --export-release "Client" builds/client/game_client.app

# Build do servidor (headless)
godot --headless --export-release "Server" builds/server/game_server.app --headless
```

## Build Automatizado

Use o script `build.sh` para automatizar o processo:

```bash
# Dar permissão de execução
chmod +x build.sh

# Build de ambos (cliente e servidor)
./build.sh macos both

# Build apenas do cliente
./build.sh macos client

# Build apenas do servidor
./build.sh macos server

# Outras plataformas
./build.sh windows both
./build.sh linux both
```

## Estrutura dos Builds

Após o build, a estrutura será:

```
builds/
├── client/
│   ├── game_client.app (ou .exe, .x86_64)
│   ├── client_config.json
│   └── [outros arquivos do Godot]
└── server/
    ├── game_server.app (ou .exe, .x86_64)
    ├── server_config.json
    ├── server_data/
    │   └── game_database.db
    └── [outros arquivos do Godot]
```

## Executando os Builds

### Servidor

```bash
# macOS/Linux
./builds/server/game_server.app/Contents/MacOS/game_server
# ou
./builds/server/game_server.x86_64

# Windows
builds\server\game_server.exe
```

O servidor iniciará automaticamente na porta configurada em `server_config.json` (padrão: 5050).

### Cliente

```bash
# macOS
open builds/client/game_client.app

# Linux
./builds/client/game_client.x86_64

# Windows
builds\client\game_client.exe
```

O cliente tentará conectar ao servidor configurado em `client_config.json`.

## Configuração para Produção

### Servidor

1. **Copiar arquivos de configuração**:
   ```bash
   cp server_config.json builds/server/
   ```

2. **Criar diretório de dados**:
   ```bash
   mkdir -p builds/server/server_data
   ```

3. **Configurar permissões** (Linux):
   ```bash
   chmod +x builds/server/game_server.x86_64
   ```

### Cliente

1. **Copiar arquivo de configuração**:
   ```bash
   cp client_config.json builds/client/
   ```

2. **Atualizar IP do servidor** em `client_config.json`:
   ```json
   {
     "server": {
       "host": "192.168.1.100",
       "port": 5050
     }
   }
   ```

## Troubleshooting

### Erro: "Export preset not found"

- Verifique se os presets foram criados corretamente no editor
- Os nomes devem ser exatamente "Client" e "Server"

### Erro: "Main scene not found"

- Verifique se as cenas `main_client.tscn` e `main_server.tscn` existem
- Verifique os caminhos no preset de exportação

### Servidor não inicia

- Verifique se o arquivo `server_config.json` está presente
- Verifique as permissões do diretório `server_data`
- Verifique se a porta não está em uso

### Cliente não conecta

- Verifique o IP e porta em `client_config.json`
- Verifique se o servidor está rodando
- Verifique o firewall

## Build para Docker

Para build em Docker, veja `docs/docker-sqlite.md` e `DOCKER.md`.

## Notas

- O servidor roda em modo headless (sem interface gráfica)
- Os arquivos de configuração devem estar no mesmo diretório dos executáveis
- O banco de dados será criado automaticamente se não existir
- Para desenvolvimento, use o editor do Godot diretamente



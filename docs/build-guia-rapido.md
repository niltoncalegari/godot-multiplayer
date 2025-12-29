# Guia Rápido de Build

## Passo a Passo

### 1. Configurar Presets no Godot (Uma vez apenas)

1. Abra o projeto no Godot Editor
2. **Project → Export**
3. Clique em **Add...** e selecione sua plataforma (macOS, Windows, Linux)

#### Preset do Cliente:
- **Name**: `Client`
- **Main Scene**: `res://client/scenes/main_client.tscn`
- **Export Path**: `builds/client/game_client.app` (ou .exe/.x86_64)
- Clique em **Save**

#### Preset do Servidor:
- **Name**: `Server`  
- **Main Scene**: `res://server/scenes/main_server.tscn`
- **Export Path**: `builds/server/game_server.app` (ou .exe/.x86_64)
- ✅ Marque **Run in Headless Mode**
- Clique em **Save**

### 2. Fazer o Build

**Opção A - Via Editor:**
1. **Project → Export**
2. Selecione preset "Client" → **Export Project**
3. Selecione preset "Server" → **Export Project**

**Opção B - Via Terminal:**
```bash
# Cliente
godot --headless --export-release "Client" builds/client/game_client.app

# Servidor  
godot --headless --export-release "Server" builds/server/game_server.app --headless
```

### 3. Copiar Arquivos de Configuração

Execute o script:
```bash
./build-simple.sh
```

Ou manualmente:
```bash
mkdir -p builds/client builds/server/server_data
cp client_config.json builds/client/
cp server_config.json builds/server/
```

### 4. Executar

**Terminal 1 - Servidor:**
```bash
# macOS
./builds/server/game_server.app/Contents/MacOS/game_server

# Linux
./builds/server/game_server.x86_64

# Windows
builds\server\game_server.exe
```

**Terminal 2 - Cliente:**
```bash
# macOS
open builds/client/game_client.app

# Linux  
./builds/client/game_client.x86_64

# Windows
builds\client\game_client.exe
```

## Verificar se Funcionou

**Servidor deve mostrar:**
```
Servidor iniciado na porta 5050
Banco de dados SQLite inicializado com sucesso
```

**Cliente deve:**
- Abrir a tela de login
- Permitir registro/login
- Conectar ao servidor

## Troubleshooting

**"Export preset not found"**
→ Configure os presets no Godot Editor primeiro

**"Main scene not found"**  
→ Verifique se `main_client.tscn` e `main_server.tscn` existem

**Servidor não inicia**
→ Verifique `server_config.json` e permissões do diretório

**Cliente não conecta**
→ Verifique IP/porta em `client_config.json` e se servidor está rodando


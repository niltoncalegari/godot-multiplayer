#!/bin/bash

# Script inteligente para fazer build - encontra Godot automaticamente

set -e

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Build Automatizado - Godot Multiplayer ===${NC}"
echo ""

# Função para encontrar Godot
find_godot() {
    local godot_path=""
    
    # Tentar locais comuns no macOS
    if [ -f "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
        godot_path="/Applications/Godot.app/Contents/MacOS/Godot"
    elif [ -f "/Applications/Godot_mono.app/Contents/MacOS/Godot" ]; then
        godot_path="/Applications/Godot_mono.app/Contents/MacOS/Godot"
    elif command -v godot &> /dev/null; then
        godot_path="godot"
    else
        # Tentar encontrar em outros locais
        local possible_paths=(
            "$HOME/Applications/Godot.app/Contents/MacOS/Godot"
            "$HOME/.local/share/godot/Godot"
            "/usr/local/bin/godot"
            "/opt/godot/Godot"
        )
        
        for path in "${possible_paths[@]}"; do
            if [ -f "$path" ]; then
                godot_path="$path"
                break
            fi
        done
    fi
    
    echo "$godot_path"
}

# Encontrar Godot
echo -e "${YELLOW}Procurando Godot...${NC}"
GODOT_PATH=$(find_godot)

if [ -z "$GODOT_PATH" ] || [ "$GODOT_PATH" == "NOT_FOUND" ]; then
    echo -e "${RED}Godot não encontrado automaticamente.${NC}"
    echo ""
    echo "Por favor, informe o caminho completo do executável do Godot:"
    echo "Exemplos:"
    echo "  /Applications/Godot.app/Contents/MacOS/Godot"
    echo "  /caminho/para/godot/Godot"
    echo ""
    read -p "Caminho do Godot: " GODOT_PATH
    
    if [ ! -f "$GODOT_PATH" ]; then
        echo -e "${RED}Erro: Arquivo não encontrado: $GODOT_PATH${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Godot encontrado: $GODOT_PATH${NC}"
fi

# Verificar versão
echo -e "${YELLOW}Verificando versão do Godot...${NC}"
VERSION=$("$GODOT_PATH" --version 2>&1 | head -1)
echo "Versão: $VERSION"
echo ""

# Criar diretórios
echo -e "${YELLOW}Preparando diretórios...${NC}"
mkdir -p builds/client
mkdir -p builds/server/server_data
echo -e "${GREEN}✓ Diretórios criados${NC}"
echo ""

# Detectar plataforma
PLATFORM="macos"
CLIENT_EXT=".app"
SERVER_EXT=".app"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
    CLIENT_EXT=".x86_64"
    SERVER_EXT=".x86_64"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    PLATFORM="windows"
    CLIENT_EXT=".exe"
    SERVER_EXT=".exe"
fi

CLIENT_PATH="builds/client/game_client$CLIENT_EXT"
SERVER_PATH="builds/server/game_server$SERVER_EXT"

# Build do Cliente
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📦 Building Client...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Build do cliente
"$GODOT_PATH" --headless --export-release "Client" "$CLIENT_PATH" 2>&1 | tee /tmp/godot_client_build.log

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo -e "${GREEN}✓ Client build concluído com sucesso!${NC}"
    echo "  Local: $CLIENT_PATH"
else
    echo -e "${RED}✗ Erro ao fazer build do Client${NC}"
    echo ""
    echo "Possíveis causas:"
    echo "  1. Preset 'Client' não configurado no Godot"
    echo "  2. Cena main_client.tscn não encontrada"
    echo "  3. Export templates não instalados"
    echo ""
    echo "Log do erro:"
    tail -20 /tmp/godot_client_build.log
    exit 1
fi

echo ""

# Build do Servidor
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📦 Building Server...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Build do servidor
"$GODOT_PATH" --headless --export-release "Server" "$SERVER_PATH" --headless 2>&1 | tee /tmp/godot_server_build.log

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo -e "${GREEN}✓ Server build concluído com sucesso!${NC}"
    echo "  Local: $SERVER_PATH"
else
    echo -e "${RED}✗ Erro ao fazer build do Server${NC}"
    echo ""
    echo "Possíveis causas:"
    echo "  1. Preset 'Server' não configurado no Godot"
    echo "  2. Cena main_server.tscn não encontrada"
    echo "  3. Export templates não instalados"
    echo ""
    echo "Log do erro:"
    tail -20 /tmp/godot_server_build.log
    exit 1
fi

echo ""

# Copiar arquivos de configuração
echo -e "${YELLOW}📋 Copiando arquivos de configuração...${NC}"

if [ -f "client_config.json" ]; then
    cp client_config.json builds/client/
    echo -e "${GREEN}  ✓ client_config.json${NC}"
else
    echo -e "${YELLOW}  ⚠ client_config.json não encontrado${NC}"
fi

if [ -f "server_config.json" ]; then
    cp server_config.json builds/server/
    echo -e "${GREEN}  ✓ server_config.json${NC}"
else
    echo -e "${YELLOW}  ⚠ server_config.json não encontrado${NC}"
fi

if [ -d "server_data" ]; then
    cp -r server_data/* builds/server/server_data/ 2>/dev/null || true
    echo -e "${GREEN}  ✓ server_data${NC}"
fi

echo ""

# Resumo final
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ BUILD CONCLUÍDO COM SUCESSO!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📁 Arquivos gerados:"
echo "  Client: $CLIENT_PATH"
echo "  Server: $SERVER_PATH"
echo ""
echo "🚀 Para executar:"
echo ""
echo "  Terminal 1 - Servidor:"
if [ "$PLATFORM" == "macos" ]; then
    echo "    ./builds/server/game_server.app/Contents/MacOS/game_server"
elif [ "$PLATFORM" == "linux" ]; then
    echo "    ./builds/server/game_server.x86_64"
else
    echo "    builds\\server\\game_server.exe"
fi
echo ""
echo "  Terminal 2 - Cliente:"
if [ "$PLATFORM" == "macos" ]; then
    echo "    open builds/client/game_client.app"
elif [ "$PLATFORM" == "linux" ]; then
    echo "    ./builds/client/game_client.x86_64"
else
    echo "    builds\\client\\game_client.exe"
fi
echo ""


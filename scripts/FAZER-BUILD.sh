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

# Obter diretório do script e do projeto
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

# Mudar para o diretório raiz do projeto
cd "$PROJECT_DIR"

# Verificar se estamos no diretório correto do projeto
echo -e "${YELLOW}Verificando diretório do projeto...${NC}"
if [ ! -f "project.godot" ]; then
    echo -e "${RED}Erro: Diretório do projeto não encontrado ou inválido${NC}"
    echo "Esperado: $PROJECT_DIR"
    echo "Certifique-se de que o arquivo project.godot existe no diretório."
    exit 1
fi

echo -e "${GREEN}✓ Diretório do projeto: $(pwd)${NC}"
echo ""

# Função para encontrar Godot
find_godot() {
    local godot_path=""
    
    # Tentar locais comuns no macOS (ordem de prioridade)
    # Prioridade para versões mais recentes (4.5+)
    local possible_paths=(
        "/Applications/Godot_4.5.app/Contents/MacOS/Godot"
        "/Applications/Godot_4.5_mono.app/Contents/MacOS/Godot"
        "/Applications/Godot.app/Contents/MacOS/Godot"
        "/Applications/Godot_mono.app/Contents/MacOS/Godot"
        "/Users/niltoncalegari/Downloads/Godot_mono.app/Contents/MacOS/Godot"
        "$HOME/Applications/Godot_4.5.app/Contents/MacOS/Godot"
        "$HOME/Applications/Godot_4.5_mono.app/Contents/MacOS/Godot"
        "$HOME/Applications/Godot.app/Contents/MacOS/Godot"
        "$HOME/Applications/Godot_mono.app/Contents/MacOS/Godot"
        "$HOME/Downloads/Godot_mono.app/Contents/MacOS/Godot"
        "$HOME/Downloads/Godot.app/Contents/MacOS/Godot"
        "$HOME/.local/share/godot/Godot"
        "/usr/local/bin/godot"
        "/opt/godot/Godot"
    )
    
    # Procurar nos caminhos possíveis
    for path in "${possible_paths[@]}"; do
        if [ -f "$path" ]; then
            godot_path="$path"
            break
        fi
    done
    
    # Se não encontrou, tentar o comando godot no PATH
    if [ -z "$godot_path" ] && command -v godot &> /dev/null; then
        godot_path="godot"
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

# Verificar compatibilidade de versão
VERSION_MAJOR=$(echo "$VERSION" | cut -d'.' -f1)
VERSION_MINOR=$(echo "$VERSION" | cut -d'.' -f2)

if [ "$VERSION_MAJOR" -lt 4 ] || ([ "$VERSION_MAJOR" -eq 4 ] && [ "$VERSION_MINOR" -lt 5 ]); then
    echo -e "${YELLOW}⚠️  AVISO: Este projeto foi desenvolvido para Godot 4.5+${NC}"
    echo -e "${YELLOW}   Você está usando Godot $VERSION${NC}"
    echo -e "${YELLOW}   Alguns recursos podem não funcionar corretamente:${NC}"
    echo -e "${YELLOW}   - GDExtensions (SQLite, twovoip) podem falhar${NC}"
    echo -e "${YELLOW}   - Arquivos GLB podem não carregar${NC}"
    echo -e "${YELLOW}   - Recursos podem precisar ser reimportados${NC}"
    echo ""
    read -p "Deseja continuar mesmo assim? (s/N): " CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Ss]$ ]]; then
        echo -e "${RED}Build cancelado. Por favor, atualize para Godot 4.5+${NC}"
        exit 1
    fi
    echo ""
fi
echo ""

# Criar diretórios
echo -e "${YELLOW}Preparando diretórios de build...${NC}"
mkdir -p builds/client
mkdir -p builds/server/server_data

if [ -d "builds/client" ] && [ -d "builds/server" ]; then
    echo -e "${GREEN}✓ Diretórios criados:${NC}"
    echo "  - builds/client"
    echo "  - builds/server"
    echo "  - builds/server/server_data"
else
    echo -e "${RED}Erro ao criar diretórios de build${NC}"
    exit 1
fi
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

# Tentar primeiro "server+headless" (nome correto), depois "Server"
"$GODOT_PATH" --headless --export-release "server+headless" "$SERVER_PATH" --headless 2>&1 | tee /tmp/godot_server_build.log

# Se falhar, tentar com o nome alternativo
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo -e "${YELLOW}Tentando com preset 'Server'...${NC}"
    "$GODOT_PATH" --headless --export-release "Server" "$SERVER_PATH" --headless 2>&1 | tee /tmp/godot_server_build.log
fi

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo -e "${GREEN}✓ Server build concluído com sucesso!${NC}"
    echo "  Local: $SERVER_PATH"
else
    echo -e "${RED}✗ Erro ao fazer build do Server${NC}"
    echo ""
    echo "Possíveis causas:"
    echo "  1. Preset 'server+headless' ou 'Server' não configurado no Godot"
    echo "  2. Cena main_server.tscn não encontrada"
    echo "  3. Export templates não instalados para esta versão"
    echo "  4. Incompatibilidade de versão do Godot (projeto requer 4.5+)"
    echo ""
    echo "Verifique se os export templates estão instalados:"
    echo "  No Godot: Editor → Manage Export Templates → Download"
    echo ""
    echo "Log do erro:"
    tail -30 /tmp/godot_server_build.log | grep -E "(ERROR|preset|template)" | head -10
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
echo "📁 Arquivos gerados em: $(pwd)/builds/"
echo ""
echo "  Client: $CLIENT_PATH"
echo "  Server: $SERVER_PATH"
echo ""
echo "📂 Estrutura de diretórios:"
echo "  builds/"
echo "  ├── client/       (arquivos do cliente)"
echo "  └── server/       (arquivos do servidor)"
echo "      └── server_data/  (banco de dados)"
echo ""
echo "🚀 Para executar:"
echo ""
echo "  Terminal 1 - Servidor:"
if [ "$PLATFORM" == "macos" ]; then
    echo "    cd builds/server && ./run_server.sh"
    echo "    # OU diretamente:"
    echo "    ./builds/server/server.app/Contents/MacOS/MutliplayerTemplate"
elif [ "$PLATFORM" == "linux" ]; then
    echo "    cd builds/server && ./run_server.sh"
    echo "    # OU diretamente:"
    echo "    ./builds/server/game_server.x86_64"
else
    echo "    builds\\server\\game_server.exe"
fi
echo ""
echo "  Terminal 2 - Cliente:"
if [ "$PLATFORM" == "macos" ]; then
    echo "    cd builds/client && ./run_client.sh"
    echo "    # OU diretamente:"
    echo "    open builds/client/game_client.app"
    echo ""
    echo "  ⚠️  IMPORTANTE: Se o cliente abrir e fechar imediatamente,"
    echo "     execute pelo terminal para ver os erros:"
    echo "     cd builds/client && ./run_client.sh"
elif [ "$PLATFORM" == "linux" ]; then
    echo "    cd builds/client && ./run_client.sh"
    echo "    # OU diretamente:"
    echo "    ./builds/client/game_client.x86_64"
else
    echo "    builds\\client\\game_client.exe"
fi
echo ""


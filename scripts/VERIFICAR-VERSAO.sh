#!/bin/bash

# Script para verificar se o projeto está configurado para Godot 4.5+

set -e

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Verificação de Configuração - Godot 4.5+ ===${NC}"
echo ""

# Obter diretório do projeto (um nível acima do script)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"
cd "$PROJECT_DIR"

# Verificar project.godot
echo -e "${YELLOW}Verificando project.godot...${NC}"
if grep -q 'config/features=PackedStringArray("4.5"' project.godot 2>/dev/null; then
    echo -e "${GREEN}✓ Projeto configurado para Godot 4.5+${NC}"
else
    echo -e "${RED}✗ Projeto não está configurado para 4.5+${NC}"
    echo "  Procure por: config/features=PackedStringArray(\"4.5\""
fi

# Verificar config_version
if grep -q 'config_version=5' project.godot 2>/dev/null; then
    echo -e "${GREEN}✓ config_version=5 (Godot 4.x)${NC}"
else
    echo -e "${YELLOW}⚠ config_version pode estar desatualizado${NC}"
fi

echo ""

# Verificar GDExtensions
echo -e "${YELLOW}Verificando GDExtensions...${NC}"

# godot-sqlite
if [ -f "addons/godot-sqlite/gdsqlite.gdextension" ]; then
    COMPAT=$(grep "compatibility_minimum" addons/godot-sqlite/gdsqlite.gdextension | cut -d'"' -f2)
    if [ -n "$COMPAT" ]; then
        echo -e "${GREEN}✓ godot-sqlite: compatibilidade mínima $COMPAT${NC}"
    fi
else
    echo -e "${YELLOW}⚠ godot-sqlite não encontrado${NC}"
fi

# twovoip
if [ -f "addons/twovoip/twovoip.gdextension" ]; then
    COMPAT=$(grep "compatibility_minimum" addons/twovoip/twovoip.gdextension | cut -d'"' -f2)
    if [ -n "$COMPAT" ]; then
        echo -e "${GREEN}✓ twovoip: compatibilidade mínima $COMPAT${NC}"
    fi
else
    echo -e "${YELLOW}⚠ twovoip não encontrado${NC}"
fi

echo ""

# Verificar se Godot 4.5+ está instalado
echo -e "${YELLOW}Procurando Godot 4.5+ instalado...${NC}"

FOUND_45=false
GODOT_45_PATH=""

# Procurar em locais comuns
POSSIBLE_PATHS=(
    "/Applications/Godot_4.5.app/Contents/MacOS/Godot"
    "/Applications/Godot_4.5_mono.app/Contents/MacOS/Godot"
    "/Applications/Godot.app/Contents/MacOS/Godot"
    "/Applications/Godot_mono.app/Contents/MacOS/Godot"
    "$HOME/Applications/Godot_4.5.app/Contents/MacOS/Godot"
    "$HOME/Applications/Godot_4.5_mono.app/Contents/MacOS/Godot"
    "$HOME/Applications/Godot.app/Contents/MacOS/Godot"
    "$HOME/Applications/Godot_mono.app/Contents/MacOS/Godot"
)

for path in "${POSSIBLE_PATHS[@]}"; do
    if [ -f "$path" ]; then
        VERSION=$("$path" --version 2>&1 | head -1)
        VERSION_MAJOR=$(echo "$VERSION" | cut -d'.' -f1)
        VERSION_MINOR=$(echo "$VERSION" | cut -d'.' -f2)
        
        if [ "$VERSION_MAJOR" -eq 4 ] && [ "$VERSION_MINOR" -ge 5 ]; then
            echo -e "${GREEN}✓ Godot 4.5+ encontrado: $path${NC}"
            echo -e "${GREEN}  Versão: $VERSION${NC}"
            FOUND_45=true
            GODOT_45_PATH="$path"
            break
        elif [ "$VERSION_MAJOR" -eq 4 ] && [ "$VERSION_MINOR" -lt 5 ]; then
            echo -e "${YELLOW}⚠ Godot encontrado mas versão antiga: $VERSION${NC}"
            echo -e "${YELLOW}  Caminho: $path${NC}"
        fi
    fi
done

if [ "$FOUND_45" = false ]; then
    echo -e "${RED}✗ Godot 4.5+ não encontrado${NC}"
    echo -e "${YELLOW}  Veja docs/build/ATUALIZAR-GODOT.md para instruções de instalação${NC}"
fi

echo ""

# Verificar export templates
echo -e "${YELLOW}Verificando export templates...${NC}"
TEMPLATES_DIR="$HOME/Library/Application Support/Godot/export_templates"

if [ -d "$TEMPLATES_DIR" ]; then
    # Procurar por templates 4.5+
    FOUND_TEMPLATES=false
    for dir in "$TEMPLATES_DIR"/*; do
        if [ -d "$dir" ]; then
            DIR_NAME=$(basename "$dir")
            if [[ "$DIR_NAME" == 4.5* ]] || [[ "$DIR_NAME" == 4.6* ]] || [[ "$DIR_NAME" == 4.7* ]] || [[ "$DIR_NAME" == 4.8* ]] || [[ "$DIR_NAME" == 4.9* ]]; then
                echo -e "${GREEN}✓ Export templates encontrados: $DIR_NAME${NC}"
                FOUND_TEMPLATES=true
            fi
        fi
    done
    
    if [ "$FOUND_TEMPLATES" = false ]; then
        echo -e "${YELLOW}⚠ Export templates 4.5+ não encontrados${NC}"
        echo -e "${YELLOW}  Instale via: Editor → Manage Export Templates → Download${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Diretório de templates não encontrado${NC}"
    echo -e "${YELLOW}  Instale via: Editor → Manage Export Templates → Download${NC}"
fi

echo ""

# Resumo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Resumo:${NC}"
echo ""

if grep -q 'config/features=PackedStringArray("4.5"' project.godot 2>/dev/null && [ "$FOUND_45" = true ]; then
    echo -e "${GREEN}✅ Projeto está configurado para Godot 4.5+${NC}"
    echo -e "${GREEN}✅ Godot 4.5+ está instalado${NC}"
    echo ""
    echo -e "${GREEN}Você está pronto para fazer build!${NC}"
    echo "Execute: ./scripts/FAZER-BUILD.sh"
else
    echo -e "${YELLOW}⚠️  Algumas verificações falharam${NC}"
    echo ""
    echo "Para atualizar para Godot 4.5+:"
    echo "  1. Veja o guia: docs/build/ATUALIZAR-GODOT.md"
    echo "  2. Baixe e instale Godot 4.5+"
    echo "  3. Instale os export templates"
    echo "  4. Reabra o projeto no Godot 4.5+"
fi

echo ""


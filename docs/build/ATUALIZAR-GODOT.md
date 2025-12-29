# 🚀 Guia de Atualização para Godot 4.5+

Este guia explica como atualizar do Godot 4.2.1 para 4.5+ para garantir compatibilidade total com o projeto.

## 📋 Pré-requisitos

- Godot 4.2.1 atualmente instalado (você tem)
- Conexão com internet para download
- ~200MB de espaço em disco

## ⚡ Passo 1: Baixar Godot 4.5+

### Opção A: Godot Standard (Recomendado para este projeto)

1. Acesse: https://godotengine.org/download
2. Baixe a versão **Godot 4.5+** para macOS
3. Escolha:
   - **Standard** (sem Mono/C#) - mais leve e rápido
   - **Mono** (com C#) - se você usa scripts C#

### Opção B: Via Terminal (macOS)

```bash
# Criar diretório para downloads (se não existir)
mkdir -p ~/Downloads/Godot

# Baixar Godot 4.5 (ajuste a URL para a versão mais recente)
cd ~/Downloads/Godot
curl -L -o Godot_4.5.dmg "https://github.com/godotengine/godot/releases/download/4.5-stable/Godot_v4.5-stable_macos.universal.dmg"
```

## ⚡ Passo 2: Instalar Godot 4.5+

1. **Abra o arquivo .dmg baixado**
2. **Arraste o Godot.app para:**
   - `/Applications/` (para todos os usuários)
   - OU `~/Applications/` (apenas para você)
3. **Renomeie se necessário:**
   - Se já tiver Godot 4.2, renomeie para `Godot_4.5.app` ou `Godot_4.5_mono.app`

## ⚡ Passo 3: Instalar Export Templates

### Via Editor (Recomendado)

1. **Abra o projeto no Godot 4.5+**
2. Vá em **Editor → Manage Export Templates**
3. Clique em **Download and Install**
4. Aguarde o download (pode levar alguns minutos)
5. Verifique se apareceu: `4.5-stable` na lista

### Via Terminal (Alternativo)

```bash
# Os templates serão baixados automaticamente na primeira exportação
# Ou você pode baixar manualmente:
mkdir -p ~/Library/Application\ Support/Godot/export_templates
cd ~/Library/Application\ Support/Godot/export_templates

# Baixar templates (ajuste a URL para a versão mais recente)
curl -L -o 4.5-stable.zip "https://github.com/godotengine/godot/releases/download/4.5-stable/godot-export-templates-4.5-stable.tpz"
unzip 4.5-stable.zip
```

## ⚡ Passo 4: Atualizar o Script de Build

O script `scripts/FAZER-BUILD.sh` já está configurado para procurar Godot em vários locais. Se você instalou em um local diferente, você pode:

### Opção A: Atualizar o caminho no script

Edite `scripts/FAZER-BUILD.sh` e adicione seu caminho na função `find_godot()`:

```bash
local possible_paths=(
    "/Applications/Godot_4.5.app/Contents/MacOS/Godot"  # Adicione aqui
    "/Applications/Godot.app/Contents/MacOS/Godot"
    # ... outros caminhos
)
```

### Opção B: Deixar o script encontrar automaticamente

O script já procura em `/Applications/` e `~/Applications/`, então se você instalou lá, ele encontrará automaticamente.

## ⚡ Passo 5: Reimportar o Projeto (Importante!)

1. **Abra o projeto no Godot 4.5+**
2. O Godot vai detectar que o projeto foi criado em uma versão anterior
3. **Aguarde a reimportação automática** (pode levar alguns minutos)
4. Verifique se há erros no painel "Output" ou "Errors"

### Verificar se tudo foi reimportado:

1. Vá em **Project → Project Settings → General**
2. Verifique se não há avisos de recursos não importados
3. Se houver erros, clique em **Project → Reload Current Project**

## ⚡ Passo 6: Verificar GDExtensions

Após atualizar, verifique se os GDExtensions funcionam:

1. **Abra o projeto no Godot 4.5+**
2. Verifique o painel "Output" para erros de GDExtensions
3. Se houver erros:
   - **godot-sqlite**: Deve funcionar automaticamente
   - **twovoip**: Pode precisar ser atualizado/recompilado

## ⚡ Passo 7: Testar o Build

```bash
# Execute o script de build
./scripts/FAZER-BUILD.sh
```

O script deve:
- ✅ Encontrar o Godot 4.5+ automaticamente
- ✅ Não mostrar avisos de incompatibilidade
- ✅ Fazer build sem erros de versão

## 🔍 Verificar Versão Instalada

```bash
# Verificar qual Godot está sendo usado
/Applications/Godot_4.5.app/Contents/MacOS/Godot --version

# Ou se instalou como Godot.app
/Applications/Godot.app/Contents/MacOS/Godot --version
```

Deve mostrar algo como: `4.5.x.stable.official.xxxxx`

## ❓ Problemas Comuns

### "Godot 4.5 não encontrado pelo script"

**Solução:**
1. Verifique onde instalou o Godot
2. Execute: `find /Applications ~/Applications -name "Godot*.app" 2>/dev/null`
3. Adicione o caminho no script `scripts/FAZER-BUILD.sh`

### "Export templates não encontrados"

**Solução:**
1. Abra o Godot Editor
2. **Editor → Manage Export Templates**
3. Clique em **Download and Install**
4. Aguarde o download completo

### "Erros de GDExtensions após atualizar"

**Solução:**
1. Feche e reabra o projeto
2. Verifique se os addons estão na pasta `addons/`
3. Se persistir, pode ser necessário atualizar os addons:
   - **godot-sqlite**: Verifique se há versão compatível com 4.5
   - **twovoip**: Pode precisar ser recompilado

### "Recursos não carregam após atualizar"

**Solução:**
1. **Project → Reload Current Project**
2. Aguarde a reimportação completa
3. Se persistir, feche o editor e reabra

## ✅ Checklist de Atualização

- [ ] Godot 4.5+ baixado e instalado
- [ ] Export templates instalados
- [ ] Projeto aberto no Godot 4.5+ sem erros
- [ ] Recursos reimportados com sucesso
- [ ] GDExtensions funcionando
- [ ] Script `./scripts/FAZER-BUILD.sh` encontra o Godot 4.5+
- [ ] Build do cliente funciona
- [ ] Build do servidor funciona

## 📚 Links Úteis

- **Download Godot**: https://godotengine.org/download
- **Release Notes 4.5**: https://godotengine.org/article/dev-snapshot-godot-4-5-beta-1/
- **Documentação**: https://docs.godotengine.org/

---

**Nota**: Após atualizar, é recomendado fazer um commit das mudanças de versão (se houver arquivos `.godot/` modificados) ou adicionar `.godot/` ao `.gitignore` se ainda não estiver.


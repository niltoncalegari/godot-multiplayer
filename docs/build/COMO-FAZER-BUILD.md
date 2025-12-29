# 🚀 Como Fazer o Build

> ⚠️ **IMPORTANTE**: Este projeto requer **Godot 4.5 ou superior**.
> Se você está usando uma versão anterior, veja o guia: **[ATUALIZAR-GODOT.md](./ATUALIZAR-GODOT.md)**

## ⚡ Passo 1: Configurar Presets no Godot

1. Abra o projeto no **Godot Editor**
2. **Project → Export...**
3. Clique em **"Add..."** → Selecione **"macOS"** (ou sua plataforma)

### Preset "Client":
- **Name:** `Client`
- Aba **"Resources"** → **Export Path:** `builds/client/game_client.app` (use o ícone de pasta 📁)
- Aba **"Options"** → **Embed PCK:** ✅ MARCADO

### Preset "Server":
- **Name:** `Server`
- Aba **"Resources"** → **Export Path:** `builds/server/game_server.app`
- Aba **"Options"** → **Embed PCK:** ✅ MARCADO + **Run in Headless Mode:** ✅ MARCADO

**Salve** cada preset.

---

## ⚡ Passo 2: Executar o Build

```bash
./scripts/FAZER-BUILD.sh
```

O script vai:
- ✅ Procurar o Godot automaticamente
- ✅ Verificar compatibilidade de versão
- ✅ Fazer build do cliente e servidor
- ✅ Copiar arquivos de configuração

Se o Godot não for encontrado, o script pedirá o caminho.

> ⚠️ **IMPORTANTE**: Este projeto requer **Godot 4.5 ou superior**. 
> Se você estiver usando uma versão anterior, pode haver erros de compatibilidade.

---

## ⚡ Passo 3: Executar

**Terminal 1 - Servidor:**
```bash
cd builds/server
./run_server.sh
```

**Terminal 2 - Cliente:**
```bash
cd builds/client
./run_client.sh
```

> 💡 **Dica:** Os scripts `run_client.sh` e `run_server.sh` mostram os erros no terminal, facilitando o debug.

---

## ❓ Problemas?

**"Export preset not found"**
→ Configure os presets primeiro (Passo 1)

**"No export template found"**
→ No Godot: **Editor → Manage Export Templates → Download**

**Godot não encontrado**
→ O script pedirá o caminho. Exemplo: `/Applications/Godot.app/Contents/MacOS/Godot`

**Aplicação abre e fecha imediatamente**
→ Execute pelo terminal para ver os erros:
```bash
cd builds/client
./run_client.sh
```

**Erro: "Can't open dynamic library: addons/twovoip/libs/..."**
→ Este é um problema conhecido com GDExtensions no macOS. O framework está em `Contents/Frameworks/` mas o GDExtension não o encontra. Possíveis soluções:
1. Verifique se o preset de exportação tem **"Embed PCK"** marcado
2. Tente fazer rebuild do projeto
3. Verifique se os frameworks estão em `builds/client/game_client.app/Contents/Frameworks/`

**Erro: "Invalid export preset name: Server"**
→ O preset do servidor se chama **"server+headless"**, não "Server". O script agora tenta ambos automaticamente.

**Erro: "No export template found"**
→ Você precisa instalar os export templates:
1. Abra o Godot Editor
2. **Editor → Manage Export Templates**
3. Clique em **Download** para sua versão
4. Aguarde o download e instalação

**Erro: "format version (6) or engine version (4.5) which are not supported"**
→ Você está usando uma versão do Godot anterior à 4.5. Este projeto requer **Godot 4.5+**.
- **Solução**: Veja o guia completo: **[ATUALIZAR-GODOT.md](./ATUALIZAR-GODOT.md)**
- Ou reimporte os assets no editor (pode não resolver todos os problemas)

**Erro: "get_godot_version2 not found" ou "GDExtension initialization function returned an error"**
→ Os GDExtensions (SQLite, twovoip) foram compilados para Godot 4.5+ e não funcionam em versões anteriores.
- **Solução**: Atualize para Godot 4.5+ ou recompile os GDExtensions para sua versão

---

## 📚 Documentação Completa

Veja `docs/build.md` para mais detalhes.



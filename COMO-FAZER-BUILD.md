# 🚀 Como Fazer o Build

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
./FAZER-BUILD.sh
```

O script vai:
- ✅ Procurar o Godot automaticamente
- ✅ Fazer build do cliente e servidor
- ✅ Copiar arquivos de configuração

Se o Godot não for encontrado, o script pedirá o caminho.

---

## ⚡ Passo 3: Executar

**Terminal 1 - Servidor:**
```bash
./builds/server/game_server.app/Contents/MacOS/game_server
```

**Terminal 2 - Cliente:**
```bash
open builds/client/game_client.app
```

---

## ❓ Problemas?

**"Export preset not found"**
→ Configure os presets primeiro (Passo 1)

**"No export template found"**
→ No Godot: **Editor → Manage Export Templates → Download**

**Godot não encontrado**
→ O script pedirá o caminho. Exemplo: `/Applications/Godot.app/Contents/MacOS/Godot`

---

## 📚 Documentação Completa

Veja `docs/build.md` para mais detalhes.


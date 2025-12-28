# Instalação do Plugin SQLite

## Opção 1: Usar o plugin godot-sqlite (Recomendado)

1. Baixe o plugin de: https://github.com/2shady4u/godot-sqlite/releases
2. Extraia o conteúdo na pasta `addons/godot-sqlite/`
3. Ative o plugin em: Project > Project Settings > Plugins
4. O plugin deve aparecer como "SQLite"

## Opção 2: Usar GDExtension manualmente

Se preferir instalar manualmente:

1. Baixe os binários do plugin para sua plataforma
2. Coloque os arquivos `.so` (Linux), `.dll` (Windows) ou `.dylib` (macOS) na pasta `addons/godot-sqlite/libs/`
3. Configure o arquivo `godot-sqlite.gdextension` com os caminhos corretos

## Verificação

Após instalar, o sistema de banco de dados deve funcionar automaticamente. 

### Desenvolvimento
O banco será criado em `user://game_database.db` quando o servidor iniciar.

### Produção (Docker)
O banco será criado em `/app/server_data/game_database.db` quando o servidor iniciar no Docker.

## Status da Instalação

✅ **Plugin instalado e configurado**
- Versão: v4.6
- Arquivo: `gdsqlite.gdextension`
- Símbolo: `sqlite_library_init`
- Pronto para uso

## Nota

O plugin é necessário apenas no servidor. O cliente não precisa do SQLite.

## Docker

O SQLite funciona perfeitamente em Docker usando volumes. Veja `docs/docker-sqlite.md` para mais detalhes.

## Troubleshooting

Se o plugin não carregar:
1. Recarregue o projeto (Project > Reload Current Project)
2. Verifique se está usando Godot 4.1+
3. Verifique se os binários estão em `bin/`
4. Verifique os logs do Godot para erros específicos


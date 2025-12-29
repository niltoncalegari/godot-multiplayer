# Scripts de Build e Verificação

Esta pasta contém os scripts executáveis para build e verificação do projeto.

## Scripts Disponíveis

### `FAZER-BUILD.sh`
Script principal para fazer build do cliente e servidor.

**Uso:**
```bash
./scripts/FAZER-BUILD.sh
```

**Funcionalidades:**
- Procura Godot automaticamente
- Verifica compatibilidade de versão
- Faz build do cliente e servidor
- Copia arquivos de configuração

### `VERIFICAR-VERSAO.sh`
Script para verificar se o projeto está configurado para Godot 4.5+.

**Uso:**
```bash
./scripts/VERIFICAR-VERSAO.sh
```

**Funcionalidades:**
- Verifica configuração do `project.godot`
- Verifica compatibilidade dos GDExtensions
- Procura Godot 4.5+ instalado
- Verifica export templates

## Requisitos

- Bash 3.2+ (macOS/Linux)
- Godot 4.5+ instalado
- Export templates instalados

## Documentação

Para mais informações sobre build e atualização, veja:
- [docs/build/COMO-FAZER-BUILD.md](../docs/build/COMO-FAZER-BUILD.md)
- [docs/build/ATUALIZAR-GODOT.md](../docs/build/ATUALIZAR-GODOT.md)


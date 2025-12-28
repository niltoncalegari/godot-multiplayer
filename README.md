# Godot Multiplayer - MMORPG

Projeto de MMORPG inspirado no MuOnline, desenvolvido em Godot 4 com sistema de multiplayer cliente/servidor.

## 🎮 Sobre o Projeto

Este projeto está sendo desenvolvido como um MMORPG com:
- Sistema de classes (Guerreiro, Mago, Arqueiro, Elfo)
- Sistema de atributos e distribuição de pontos
- Sistema de equipamentos e inventário
- Combate PvE e PvP
- Persistência de dados em banco de dados
- Separação cliente/servidor em executáveis distintos

## 📚 Documentação

Toda a documentação do projeto está na pasta [`docs/`](./docs/):

- **[Game Design Document](./docs/game-design.md)** - Design completo do jogo
- **[Arquitetura](./docs/arquitetura.md)** - Arquitetura técnica cliente/servidor
- **[Regras do Projeto](./docs/regras-projeto.md)** - Convenções e padrões de código
- **[Features](./docs/features.md)** - Roadmap e status das features
- **[Guia de Migração](./docs/migracao.md)** - Guia para migrar código existente

## 🏗️ Estrutura do Projeto

```
godot-multiplayer/
├── shared/          # Código compartilhado entre cliente e servidor
├── client/          # Código específico do cliente
├── server/          # Código específico do servidor
├── assets/          # Assets do jogo (modelos, texturas, etc.)
├── docs/            # Documentação do projeto
└── ...
```

## 🚀 Funcionalidades Atuais

- ✅ Sistema de multiplayer básico (cliente/servidor)
- ✅ Sistema de spawn de players
- ✅ Sistema de movimentação (terceira pessoa)
- ✅ Sistema de VoIP (voz)
- ✅ Sistema de UI básico
- ✅ Sistema de user data básico

## 📋 Próximas Features

Veja o [roadmap completo](./docs/features.md) para mais detalhes.

### Em Desenvolvimento
- Separação cliente/servidor em executáveis distintos
- Sistema de banco de dados
- Sistema de autenticação/login

### Planejadas
- Sistema de classes e atributos
- Sistema de equipamentos
- Sistema de combate (PvE e PvP)
- Sistema de níveis e experiência

## 🛠️ Como Usar

### Desenvolvimento

1. Abra o projeto no Godot 4.5+
2. Para testar como servidor: Execute com `--server` como argumento de linha de comando
3. Para testar como cliente: Execute normalmente

### Exportação

- **Cliente**: Exportar cena `client/scenes/main_client.tscn`
- **Servidor**: Exportar cena `server/scenes/main_server.tscn` (headless)

## 📸 Screenshots

<img src="screenshots\hub.png" width="500"> <br/> <br/>
<img src="screenshots\editor.png" width="500"> <br/> <br/>

[player/player.gd](player/player.gd)

<img src="screenshots\interpolation.png" width="500"> <br/> <br/>

## 🙏 Créditos

* Platformer Kit (2.2) - https://www.kenney.nl (CC0)
* VoIP extension for Godot 4 - https://github.com/goatchurchprime/two-voip-godot-4 (MIT)
* RoboBlast: Third-Person Shooter demo - https://github.com/gdquest-demos/godot-4-3d-third-person-controller (MIT and CC-By 4.0)

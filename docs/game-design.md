# Game Design Document (GDD)

## Visão Geral

Jogo multiplayer inspirado no MuOnline, mantendo a mecânica de movimentação atual (terceira pessoa com física), mas adicionando sistemas de RPG como classes, equipamentos, sistema de atributos, PVE e PVP.

## Conceito Principal

MMORPG com foco em:
- **Progressão de Personagem**: Sistema de classes, níveis e atributos
- **Sistema de Equipamentos**: Armaduras e itens modulares
- **PvE**: Combate contra monstros e bosses
- **PvP**: Combate entre jogadores
- **Persistência**: Dados salvos em banco de dados

## Sistema de Classes

### Classes Planejadas

1. **Guerreiro (Warrior)**
   - Foco em força e resistência
   - Combate corpo a corpo
   - Alta vida e defesa

2. **Mago (Wizard)**
   - Foco em inteligência e magia
   - Combate à distância com feitiços
   - Baixa vida, alta dano mágico

3. **Arqueiro (Archer)**
   - Foco em agilidade e precisão
   - Combate à distância com arco
   - Velocidade e crítico

4. **Elfo (Elf)**
   - Foco em suporte e versatilidade
   - Buffs e debuffs
   - Equilíbrio entre ataque e defesa

*(Podem ser adicionadas mais classes no futuro)*

## Sistema de Atributos

### Atributos Base

- **Força (STR)**: Aumenta dano físico e capacidade de carga
- **Agilidade (AGI)**: Aumenta velocidade de ataque, velocidade de movimento e chance de crítico
- **Vitalidade (VIT)**: Aumenta vida máxima e regeneração de vida
- **Inteligência (INT)**: Aumenta dano mágico e mana máxima
- **Comando (CMD)**: Aumenta dano de pets e capacidade de liderança

### Sistema de Pontos

- Jogadores ganham pontos de atributo ao subir de nível
- Pontos podem ser distribuídos livremente entre os atributos
- Cada classe tem recomendações de build, mas permite flexibilidade

## Sistema de Níveis e Experiência

- Sistema de níveis (ex: 1-400, similar ao MuOnline)
- Experiência ganha através de:
  - Derrotar monstros (PvE)
  - Derrotar outros jogadores (PvP)
  - Completar quests (futuro)
- Penalidades de morte (perda de experiência/level)

## Sistema de Equipamentos

### Tipos de Equipamentos

1. **Armaduras**
   - Capacete
   - Armadura
   - Calças
   - Luvas
   - Botas
   - Escudo (opcional)

2. **Armas**
   - Varia por classe:
     - Guerreiro: Espadas, Machados, Lanças
     - Mago: Cajados, Livros
     - Arqueiro: Arcos, Bestas
     - Elfo: Arcos, Cetros

3. **Acessórios**
   - Anéis
   - Amuletos
   - Asas (equipamento especial)

### Sistema de Raridade

- **Comum (Branco)**: Equipamentos básicos
- **Incomum (Verde)**: Equipamentos melhores
- **Raro (Azul)**: Equipamentos bons
- **Épico (Roxo)**: Equipamentos muito bons
- **Lendário (Laranja)**: Equipamentos excepcionais
- **Mítico (Vermelho)**: Equipamentos raríssimos

### Sistema de Melhoria

- **Upgrade (+1 a +15)**: Aumenta atributos do equipamento
- **Opções**: Adiciona atributos aleatórios
- **Sockets**: Gemas que adicionam bônus

## Sistema de Combate

### PvE (Player vs Environment)

- **Monstros**: Diferentes tipos com diferentes níveis e dificuldades
- **Bosses**: Monstros poderosos que requerem grupos
- **Spawns**: Áreas com monstros específicos
- **Drops**: Monstros dropam itens, experiência e moedas

### PvP (Player vs Player)

- **Zonas PvP**: Áreas onde PvP é permitido
- **Zonas Seguras**: Áreas onde PvP é desabilitado
- **Sistema de PK (Player Killer)**: Penalidades para jogadores que matam outros
- **Arenas**: Áreas controladas para combate PvP
- **Guild Wars**: Combate entre guildas (futuro)

### Mecânicas de Combate

- **Dano Físico**: Baseado em força e arma
- **Dano Mágico**: Baseado em inteligência e feitiços
- **Crítico**: Chance baseada em agilidade
- **Defesa**: Reduz dano recebido
- **Resistências**: Reduz dano mágico específico

## Sistema de Inventário

- **Inventário**: Espaço limitado para itens
- **Armazenamento**: Banco para guardar itens
- **Venda**: NPCs para vender itens
- **Troca**: Sistema de troca entre jogadores

## Sistema de Quests (Futuro)

- **Quests de História**: Progressão da narrativa
- **Quests Diárias**: Recompensas diárias
- **Quests de Repetição**: Para farmar experiência/recursos

## Sistema de Guildas (Futuro)

- **Criação de Guildas**: Jogadores podem criar guildas
- **Guild Wars**: Combate entre guildas
- **Bônus de Guilda**: Benefícios para membros

## Progressão e Endgame

- **Níveis**: 1-400 (ou mais)
- **Transcendência**: Sistema de resetar nível mantendo alguns benefícios
- **Raids**: Conteúdo endgame para grupos
- **Rankings**: Sistema de classificação de jogadores

## Assets Modulares

- **Personagens**: Modelos modulares para diferentes classes
- **Armaduras**: Peças separadas que podem ser combinadas
- **Armas**: Modelos diferentes por tipo e raridade
- **Monstros**: Modelos modulares para diferentes tipos
- **Ambientes**: Assets modulares para criar diferentes áreas

## Notas de Design

- Manter a mecânica de movimentação atual (terceira pessoa com física)
- Sistema de câmera atual funciona bem
- Adicionar animações de combate
- Sistema de UI para inventário, atributos, equipamentos
- Sistema de notificações para drops, level up, etc.


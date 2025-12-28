# Features e Plano de Desenvolvimento

## Status das Features

### ✅ Completas

- [x] Sistema de multiplayer básico (cliente/servidor)
- [x] Sistema de spawn de players
- [x] Sistema de movimentação (terceira pessoa)
- [x] Sistema de VoIP (voz)
- [x] Sistema de UI básico
- [x] Sistema de user data básico

### 🚧 Em Desenvolvimento

- [ ] Separação cliente/servidor em executáveis distintos
- [ ] Sistema de banco de dados
- [ ] Sistema de autenticação/login

### 📋 Planejadas

#### Fase 1: Fundação (Atual)
- [ ] Reorganizar estrutura de pastas (shared/client/server)
- [ ] Criar sistema de exportação separado
- [ ] Implementar banco de dados básico
- [ ] Sistema de autenticação e registro
- [ ] Sistema de salvamento de personagem

#### Fase 2: Sistema de RPG Básico
- [ ] Sistema de classes
- [ ] Sistema de níveis e experiência
- [ ] Sistema de atributos (STR, AGI, VIT, INT, CMD)
- [ ] Sistema de distribuição de pontos
- [ ] UI para atributos e status

#### Fase 3: Sistema de Equipamentos
- [ ] Sistema de inventário
- [ ] Sistema de equipamentos (armaduras e armas)
- [ ] Sistema de raridade de itens
- [ ] Visualização de equipamentos no personagem
- [ ] Sistema de stats de equipamentos

#### Fase 4: Sistema de Combate
- [ ] Sistema de combate básico
- [ ] Sistema de dano (físico e mágico)
- [ ] Sistema de defesa e resistências
- [ ] Sistema de crítico
- [ ] Animações de combate

#### Fase 5: PvE
- [ ] Sistema de spawn de monstros
- [ ] IA básica para monstros
- [ ] Sistema de drops
- [ ] Sistema de experiência por derrota
- [ ] Diferentes tipos de monstros

#### Fase 6: PvP
- [ ] Sistema de zonas PvP
- [ ] Sistema de zonas seguras
- [ ] Sistema de combate PvP
- [ ] Sistema de PK (Player Killer)
- [ ] Penalidades de morte PvP

#### Fase 7: Melhorias e Polimento
- [ ] Sistema de upgrade de equipamentos
- [ ] Sistema de opções em equipamentos
- [ ] Sistema de sockets e gemas
- [ ] Sistema de quests básico
- [ ] Sistema de guildas

#### Fase 8: Endgame
- [ ] Sistema de transcendência
- [ ] Raids e bosses
- [ ] Sistema de rankings
- [ ] Conteúdo endgame

## Prioridades

### Alta Prioridade
1. Separação cliente/servidor
2. Sistema de banco de dados
3. Sistema de autenticação
4. Sistema de classes e atributos básico

### Média Prioridade
1. Sistema de equipamentos
2. Sistema de combate
3. PvE básico

### Baixa Prioridade
1. PvP avançado
2. Sistema de quests
3. Sistema de guildas
4. Conteúdo endgame

## Roadmap Visual

```
Fase 1: Fundação ──────────────────────────────► [Em Progresso]
Fase 2: RPG Básico ────────────────────────────► [Planejado]
Fase 3: Equipamentos ──────────────────────────► [Planejado]
Fase 4: Combate ───────────────────────────────► [Planejado]
Fase 5: PvE ───────────────────────────────────► [Planejado]
Fase 6: PvP ───────────────────────────────────► [Planejado]
Fase 7: Melhorias ─────────────────────────────► [Planejado]
Fase 8: Endgame ───────────────────────────────► [Planejado]
```

## Notas de Desenvolvimento

### Decisões Técnicas Pendentes

- [ ] Escolher banco de dados (SQLite para dev, PostgreSQL/MySQL para prod)
- [ ] Definir sistema de autenticação (JWT, session, etc.)
- [ ] Definir formato de dados de rede (JSON, binary, etc.)
- [ ] Definir sistema de versionamento de protocolo

### Dependências Futuras

- Assets modulares de personagens
- Assets modulares de armaduras
- Assets modulares de armas
- Assets de monstros
- Assets de ambientes

### Considerações

- Manter compatibilidade com sistema atual de VoIP
- Manter sistema de movimentação atual
- Considerar performance em servidor headless
- Considerar escalabilidade do banco de dados

## Métricas de Sucesso

### Técnicas
- Servidor headless funcionando
- Cliente conectando a servidor remoto
- Banco de dados persistindo dados corretamente
- Sistema de autenticação seguro

### Gameplay
- Sistema de classes funcionando
- Sistema de equipamentos funcionando
- Combate PvE funcionando
- Combate PvP funcionando

## Atualizações

- **2024-XX-XX**: Criação do documento
- Adicionar atualizações conforme desenvolvimento progride


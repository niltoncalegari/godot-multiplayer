# Regras do Projeto

## Estrutura de Código

### Organização de Pastas

```
godot-multiplayer/
├── shared/          # Código compartilhado entre cliente e servidor
├── client/          # Código específico do cliente
├── server/          # Código específico do servidor
├── assets/          # Assets do jogo (modelos, texturas, etc.)
├── docs/            # Documentação do projeto
└── ...
```

### Convenções de Nomenclatura

- **Scripts GDScript**: snake_case (ex: `player_controller.gd`)
- **Classes**: PascalCase (ex: `PlayerController`)
- **Variáveis**: snake_case (ex: `player_health`)
- **Constantes**: UPPER_SNAKE_CASE (ex: `MAX_PLAYERS`)
- **Sinais**: snake_case (ex: `player_died`)

### Padrões de Código

- **Comentários**: Usar comentários em português para explicar lógica complexa
- **Documentação**: Classes e funções públicas devem ter documentação
- **Validação**: Sempre validar dados recebidos do cliente no servidor
- **Autoridade**: Servidor sempre tem autoridade sobre estado do jogo

## Arquitetura Cliente/Servidor

### Princípios

1. **Servidor é Autoridade**: O servidor sempre decide o estado final do jogo
2. **Validação no Servidor**: Todo input do cliente deve ser validado no servidor
3. **Predição do Cliente**: Cliente pode prever ações para melhor responsividade
4. **Reconciliação**: Servidor corrige predições incorretas do cliente

### Comunicação

- **RPCs**: Usar `@rpc` para comunicação entre cliente e servidor
- **Sincronização**: Usar `MultiplayerSynchronizer` para dados que precisam ser sincronizados
- **Validação**: Sempre validar dados em RPCs do servidor

## Banco de Dados

### Tecnologia

- **SQLite** para desenvolvimento local
- **PostgreSQL** ou **MySQL** para produção (a definir)

### Estrutura de Dados

- **Tabela de Usuários**: Login, senha (hash), email, etc.
- **Tabela de Personagens**: Dados do personagem (nível, experiência, atributos, etc.)
- **Tabela de Inventário**: Itens do personagem
- **Tabela de Equipamentos**: Equipamentos equipados
- **Tabela de Localização**: Última posição do personagem

### Segurança

- **Senhas**: Sempre usar hash (bcrypt ou similar)
- **SQL Injection**: Usar prepared statements
- **Validação**: Validar todos os dados antes de inserir no banco

## Versionamento

### Git

- **Branches**: 
  - `main`: Código estável
  - `develop`: Desenvolvimento ativo
  - `feature/*`: Features específicas
  - `fix/*`: Correções de bugs
- **Commits**: Mensagens em português, descritivas
- **Pull Requests**: Revisão obrigatória antes de merge

## Exportação

### Cliente

- Executável sem interface de servidor
- Apenas funcionalidades de cliente
- Conecta-se a servidor remoto

### Servidor

- Executável headless (sem interface gráfica)
- Apenas funcionalidades de servidor
- Otimizado para performance

## Assets

### Organização

- **Modelos 3D**: `assets/models/`
- **Texturas**: `assets/textures/`
- **Animações**: `assets/animations/`
- **Sons**: `assets/sounds/`
- **UI**: `assets/ui/`

### Convenções

- Nomes descritivos em inglês
- Versões organizadas por tipo
- Assets modulares quando possível

## Testes

### Tipos de Testes

- **Testes Unitários**: Para funções críticas
- **Testes de Integração**: Para sistemas complexos
- **Testes de Performance**: Para otimização

### Ferramentas

- Godot's built-in testing (quando disponível)
- Testes manuais em ambiente controlado

## Performance

### Otimizações

- **LOD**: Level of Detail para modelos 3D
- **Occlusion Culling**: Ocultar objetos fora de vista
- **Pooling**: Reutilizar objetos quando possível
- **Compressão**: Comprimir dados de rede quando necessário

### Métricas

- **FPS**: Manter acima de 60 FPS
- **Latência**: Reduzir latência de rede
- **Uso de Memória**: Monitorar uso de memória

## Segurança

### Rede

- **Validação**: Validar todos os dados recebidos
- **Rate Limiting**: Limitar requisições por cliente
- **Anti-Cheat**: Detectar e prevenir trapaças

### Dados

- **Criptografia**: Criptografar dados sensíveis
- **Backup**: Fazer backup regular do banco de dados
- **Logs**: Manter logs de ações importantes

## Documentação

### Manutenção

- Atualizar documentação quando código muda
- Documentar decisões importantes
- Manter arquitetura atualizada

### Tipos de Documentação

- **Game Design Document**: Design do jogo
- **Arquitetura**: Estrutura técnica
- **API**: Documentação de funções públicas
- **Guias**: Guias para desenvolvedores


# Sistema de Autenticação

## Visão Geral

O sistema de autenticação gerencia:
- Registro de novos usuários
- Login de usuários existentes
- Sessões de usuários conectados
- Validação de credenciais

## Componentes

### AuthManager
- Gerencia registro e login
- Mantém sessões de usuários logados
- Valida credenciais contra o banco de dados

### DatabaseManager
- Gerencia conexão com SQLite
- Cria e mantém tabelas
- Executa queries de forma segura (prepared statements)

### CharacterManager
- Carrega dados do personagem do banco
- Salva dados do personagem
- Gerencia criação de personagens padrão

## Integração com Sistema de Conexão

O sistema de autenticação deve ser integrado com o `Connection` existente:

1. Quando um cliente conecta, o servidor deve solicitar autenticação
2. O cliente envia credenciais via RPC
3. O servidor valida e responde
4. Se autenticado, o servidor carrega o personagem e permite spawn

## RPCs Necessários

```gdscript
# No servidor
@rpc("any_peer", "call_remote", "reliable")
func register_user(username: String, email: String, password: String) -> void

@rpc("any_peer", "call_remote", "reliable")
func login_user(username: String, password: String) -> void

# Respostas do servidor
@rpc("authority", "call_remote", "reliable")
func authentication_result(success: bool, message: String, character_data: Dictionary) -> void
```

## Segurança

- Senhas são hasheadas com SHA-256 + salt
- Usa prepared statements para prevenir SQL injection
- Valida todos os dados de entrada
- Limita tentativas de login (implementar rate limiting)

## Próximos Passos

1. Integrar com sistema de conexão existente
2. Criar UI de login/registro no cliente
3. Implementar sistema de tokens/sessões
4. Adicionar rate limiting
5. Implementar logout automático


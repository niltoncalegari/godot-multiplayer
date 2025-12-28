# Sistema de Configuração Externa

O projeto utiliza arquivos JSON externos para configuração, permitindo ajustar parâmetros do servidor e cliente sem modificar o código.

## Arquivos de Configuração

### `server_config.json`
Configurações do servidor, incluindo:
- **server**: Porta, máximo de clientes, endereço de bind
- **database**: Tipo, caminho, backup, performance
- **authentication**: Timeout de sessão, tentativas de login

### `client_config.json`
Configurações do cliente, incluindo:
- **server**: Host, porta, uso de localhost no editor
- **connection**: Timeout, tentativas de reconexão, delay

## Localização dos Arquivos

Os arquivos de configuração são procurados na seguinte ordem:

1. **Diretório do executável** (produção) - `./server_config.json` ou `./client_config.json`
2. **Diretório do projeto** (desenvolvimento) - na raiz do projeto
3. **Valores padrão** - se nenhum arquivo for encontrado

## Exemplo de Uso

### Servidor

```json
{
	"server": {
		"port": 5050,
		"max_clients": 32,
		"bind_address": "0.0.0.0"
	},
	"database": {
		"type": "sqlite",
		"path": "server_data/game_database.db",
		"backup": {
			"enabled": true,
			"interval_hours": 6,
			"max_backups": 10
		},
		"performance": {
			"cache_size_kb": 10000,
			"journal_mode": "WAL"
		}
	},
	"authentication": {
		"session_timeout_seconds": 3600,
		"max_login_attempts": 5
	}
}
```

### Cliente

```json
{
	"server": {
		"host": "localhost",
		"port": 5050,
		"use_localhost_in_editor": true
	},
	"connection": {
		"timeout_seconds": 10,
		"reconnect_attempts": 3,
		"reconnect_delay_seconds": 2
	}
}
```

## Configuração do Banco de Dados

O caminho do banco de dados pode ser:
- **Relativo**: Resolvido em relação ao executável/projeto
- **Absoluto**: Caminho completo do sistema
- **user://**: Diretório de dados do usuário (fallback)

Exemplo de caminho relativo:
```json
{
	"database": {
		"path": "server_data/game_database.db"
	}
}
```

Exemplo de caminho absoluto (Docker):
```json
{
	"database": {
		"path": "/app/server_data/game_database.db"
	}
}
```

## Configuração do Servidor de Conexão

Para produção, configure o IP do servidor no `client_config.json`:

```json
{
	"server": {
		"host": "192.168.1.100",
		"port": 5050
	}
}
```

## Criar Arquivos de Exemplo

Para criar arquivos de configuração de exemplo, use o método:

```gdscript
ConfigManager.create_example_configs()
```

Isso criará `server_config.json` e `client_config.json` na raiz do projeto com valores padrão.

## Notas

- Os arquivos de configuração são carregados automaticamente na inicialização
- Se um arquivo não for encontrado, valores padrão são usados
- Alterações nos arquivos requerem reinicialização do servidor/cliente
- Em produção, coloque os arquivos de configuração no mesmo diretório do executável


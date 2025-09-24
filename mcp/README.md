# MCP Server for macOS Dotfiles

AI agent integration for dotfiles management through Model Context Protocol.

## Features

- **Installation Management**: Install, update, and configure dotfiles
- **Backup & Restore**: Create backups and restore from them
- **System Diagnostics**: Run health checks and diagnostics
- **Alias Management**: List and manage shell aliases
- **Testing**: Run configuration tests
- **Performance Monitoring**: Benchmark shell startup times

## Installation

```bash
pip install -r requirements.txt
chmod +x server.py
```

## Usage

### Claude Desktop Integration

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "dotfiles-manager": {
      "command": "python3",
      "args": ["/Users/ishubham/.dotfiles/mcp/server.py"],
      "env": {
        "DOTFILES_DIR": "/Users/ishubham/.dotfiles"
      }
    }
  }
}
```

## Available Tools

| Tool | Description |
|------|-------------|
| `install_dotfiles` | Install or update dotfiles configuration |
| `backup_dotfiles` | Create backup of current configuration |
| `restore_dotfiles` | Restore from backup |
| `update_dotfiles` | Update dotfiles and dependencies |
| `test_dotfiles` | Run configuration tests |
| `doctor_dotfiles` | Run system diagnostics |
| `list_aliases` | List available aliases |
| `get_dotfiles_status` | Get current status |
| `clean_dotfiles` | Clean up broken symlinks |
| `benchmark_shell` | Benchmark shell startup time |

## Architecture

- `server.py` - Main MCP server implementation
- `tools.py` - Tool implementations
- `utils.py` - Utility functions
- `config.py` - Configuration settings
- `requirements.txt` - Python dependencies
- `config.json` - Claude Desktop configuration

## Security

- Commands executed in dotfiles directory only
- 5-minute timeout protection
- No arbitrary command execution
- Only predefined make targets executed

## Development

```bash
python3 server.py
```

## License

MIT License

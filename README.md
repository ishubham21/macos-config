# macOS Dotfiles

A comprehensive, production-ready dotfiles configuration for macOS developers. This setup provides a complete development environment with intelligent automation, performance optimization, and extensive customization options.

## 🚀 Key Features

- **macOS Native**: Optimized specifically for macOS with Apple Silicon and Intel support
- **Modular Design**: Clean separation of concerns with logical component organization
- **Performance First**: Lazy loading, optimized startup times, and efficient resource usage
- **Developer Focused**: Pre-configured for modern development workflows and tools
- **Intelligent Automation**: Smart package management, plugin detection, and environment setup
- **Comprehensive Tooling**: 200+ aliases, 50+ functions, and extensive utility commands
- **Safe Operations**: Automatic backups, dry-run modes, and rollback capabilities
- **AI Integration**: MCP server for AI agent interaction and management
- **Extensible**: Easy customization and plugin system for personal preferences

## 🏗️ Architecture Overview

This dotfiles setup follows a modular architecture designed for maintainability and extensibility:

```
~/.dotfiles/
├── 📦 Core Components
│   ├── install.sh              # Automated installation & setup
│   ├── Makefile                # Build automation & maintenance tasks
│   └── README.md               # Documentation & usage guide
│
├── 🐚 Shell Configuration (zsh/)
│   ├── .zshrc                  # Main shell configuration entry point
│   ├── aliases.zsh             # 200+ productivity aliases
│   ├── exports.zsh              # Environment variables & settings
│   ├── functions.zsh            # 50+ custom utility functions
│   ├── path.zsh                # Intelligent PATH management
│   └── plugins.zsh             # Oh My Zsh plugin configuration
│
├── 🔧 Development Tools
│   ├── git/                    # Git configuration & templates
│   │   ├── .gitconfig         # Global git settings
│   │   └── .gitignore_global  # Universal ignore patterns
│   └── config/
│       └── Brewfile           # Homebrew package definitions
│
├── 🤖 AI Integration (mcp/)
│   ├── server.py               # Main MCP server
│   ├── tools.py                # Tool implementations
│   ├── utils.py                # Utility functions
│   ├── config.py               # Configuration settings
│   ├── requirements.txt        # Python dependencies
│   ├── config.json             # Claude Desktop config
│   └── README.md              # MCP documentation
│
└── 🛠️ Automation Scripts
    ├── setup_homebrew.sh       # Homebrew installation & setup
    └── macos_defaults.sh       # macOS system preferences
```

### Design Principles

- **Separation of Concerns**: Each file has a specific purpose and responsibility
- **Conditional Loading**: Components load only when needed, improving performance
- **Environment Detection**: Automatically adapts to system capabilities and installed tools
- **Safe Defaults**: Conservative settings with easy customization options
- **Documentation**: Comprehensive inline documentation and usage examples

## 🚀 Quick Start

### One-Line Installation

```bash
curl -sSL https://raw.githubusercontent.com/ishubham21/dotfiles/main/install.sh | bash
```

### Manual Installation

```bash
git clone https://github.com/ishubham21/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

### Installation Options

```bash
# Interactive installation (recommended)
make install

# Non-interactive installation
make install-force

# Minimal installation (shell only)
make install-minimal

# Development-focused installation
make install-dev
```

## 📋 System Requirements

- **macOS**: 10.15 (Catalina) or later
- **Architecture**: Apple Silicon (M1/M2/M3) or Intel x64
- **Git**: 2.20+ (installed automatically if missing)
- **Internet**: Required for package downloads and updates
- **Storage**: ~2GB for full installation, ~500MB for minimal

### Supported macOS Versions

| Version | Codename | Status | Notes |
|---------|----------|--------|-------|
| 14.x | Sonoma | ✅ Fully Supported | Recommended |
| 13.x | Ventura | ✅ Fully Supported | Recommended |
| 12.x | Monterey | ✅ Supported | Legacy support |
| 11.x | Big Sur | ⚠️ Limited | Some features may not work |
| 10.15 | Catalina | ⚠️ Limited | Legacy support only |

## 🛠️ Available Commands

### Make Commands

```bash
# Installation & Setup
make install           # Interactive installation (recommended)
make install-force     # Non-interactive installation
make install-minimal   # Minimal installation (shell only)
make install-dev       # Development-focused installation

# Maintenance & Updates
make update           # Update dotfiles and dependencies
make backup           # Backup current configuration
make restore          # Restore from backup (specify BACKUP_DIR)
make clean            # Clean up broken symlinks and temp files

# Development & Testing
make test             # Run comprehensive tests
make lint             # Lint all shell scripts
make format           # Format shell scripts
make doctor           # System diagnostics and health check

# Utilities
make help              # Show all available commands
make links             # Show all dotfiles symlinks
make edit              # Open dotfiles in editor
make status            # Show git status and system info
make benchmark         # Benchmark shell startup time
```

### Advanced Make Commands

```bash
# Plugin Management
make update-plugins    # Update Oh My Zsh and custom plugins
make update-submodules # Update git submodules

# Development Tools
make install-dev-tools # Install additional development tools
make deps              # Install development dependencies

# Git Operations
make commit            # Commit with conventional commit format
make push              # Push changes to remote
make pull              # Pull latest changes

# System Analysis
make profile           # Profile zsh startup performance
make debug             # Show makefile variables
make list              # List all available make targets
```

### Custom Commands & Aliases

| Command | Description | Category |
|---------|-------------|----------|
| **Navigation** |
| `..`, `...`, `....`, `.....` | Navigate up directories | Navigation |
| `~` | Go to home directory | Navigation |
| `-` | Go to previous directory | Navigation |
| `www`, `dev`, `proj`, `repos` | Quick navigation to common directories | Navigation |
| `dotfiles`, `dots` | Navigate to dotfiles directory | Navigation |
| **File Operations** |
| `ls`, `ll`, `la`, `lt`, `ltr` | List files (with exa if available) | File Ops |
| `cp`, `mv`, `rm`, `ln` | Safe file operations with confirmation | File Ops |
| `mkdir`, `md` | Create directories with parents | File Ops |
| `extract` | Extract various archive formats | File Ops |
| `tarzip`, `tarunzip` | Tar operations | File Ops |
| `dsclean` | Remove .DS_Store files | File Ops |
| `nodemodclean` | Remove node_modules | File Ops |
| `xcclean` | Clean Xcode derived data | File Ops |
| **System Information** |
| `h`, `history` | Show command history | System |
| `j`, `jobs` | Show running jobs | System |
| `c`, `clear`, `cls` | Clear terminal | System |
| `ps`, `psg` | Process information | System |
| `top`, `htop` | System monitoring | System |
| `du`, `df`, `free` | Disk usage information | System |
| `ping` | Ping with 5 packets | System |
| `myip`, `localip` | Get IP addresses | System |
| **Text Processing** |
| `grep`, `egrep`, `fgrep` | Text search with colors | Text |
| `search` | Case-insensitive search (ripgrep) | Text |
| `find` | File finder (fd if available) | Text |
| `cat`, `less` | Enhanced file viewing (bat if available) | Text |
| **Git Operations** |
| `g` | Git command | Git |
| `gs`, `gss` | Git status | Git |
| `gl`, `glog` | Git log with formatting | Git |
| `gd`, `gdc`, `gdh` | Git diff variations | Git |
| `gb`, `gba` | Git branch operations | Git |
| `gco`, `gcb` | Git checkout operations | Git |
| `ga`, `gaa`, `gap` | Git add operations | Git |
| `gc`, `gcm`, `gca` | Git commit operations | Git |
| `gf`, `gfa` | Git fetch operations | Git |
| `gp`, `gpo`, `gpu` | Git push operations | Git |
| `gpl`, `gpr` | Git pull operations | Git |
| `gst`, `gstp`, `gstl` | Git stash operations | Git |
| `grh`, `grhh` | Git reset operations | Git |
| `gclean` | Git clean | Git |
| `gignore`, `gunignore` | Git assume-unchanged operations | Git |
| **Development** |
| `ni`, `nis`, `nid`, `nig` | npm install variations | Node.js |
| `nt`, `nr`, `ns`, `nb` | npm run commands | Node.js |
| `nf` | npm audit fix | Node.js |
| `pn`, `pni`, `pna`, `pnd` | pnpm commands | Node.js |
| `pnt`, `pnr`, `pns`, `pnb` | pnpm run commands | Node.js |
| `y`, `ya`, `yad` | yarn commands | Node.js |
| `yr`, `ys`, `yb`, `yt` | yarn run commands | Node.js |
| `py`, `pip` | Python commands | Python |
| `venv`, `activate` | Virtual environment | Python |
| `dj`, `djr`, `djm` | Django commands | Python |
| `djmm`, `djs` | Django makemigrations/shell | Python |
| `be`, `bi`, `bu` | Bundle/Ruby commands | Ruby |
| **Docker** |
| `d`, `dc` | Docker commands | Docker |
| `dcu`, `dcd`, `dcl` | Docker Compose operations | Docker |
| `dps`, `dpsa` | Docker ps variations | Docker |
| `di`, `drmi` | Docker image operations | Docker |
| `dprune`, `dstop`, `drm` | Docker cleanup | Docker |
| **Kubernetes** |
| `k` | kubectl command | Kubernetes |
| `kgp`, `kgs`, `kgd`, `kgn` | kubectl get operations | Kubernetes |
| `kd`, `kl`, `ke` | kubectl describe/logs/exec | Kubernetes |
| `kctx`, `kns` | kubectl context/namespace | Kubernetes |
| **Database** |
| `pgstart`, `pgstop`, `pgrestart` | PostgreSQL services | Database |
| `mystart`, `mystop`, `myrestart` | MySQL services | Database |
| `redisstart`, `redisstop`, `redisrestart` | Redis services | Database |
| **Web Development** |
| `serve`, `serve8000`, `serve3000` | Start HTTP server | Web Dev |
| `phpserve` | PHP development server | Web Dev |
| `chrome`, `firefox`, `safari` | Browser shortcuts | Web Dev |
| **System Administration** |
| `brewup`, `brewinfo`, `brewsize` | Homebrew operations | System |
| `flushdns` | Flush DNS cache | System |
| `showfiles`, `hidefiles` | Toggle hidden files | System |
| `osupdate` | macOS system update | System |
| `hidedesktop`, `showdesktop` | Toggle desktop icons | System |
| **Security** |
| `gpglist`, `gpgexport` | GPG operations | Security |
| `sshconfig`, `sshconf` | Edit SSH config | Security |
| `sshkey` | Copy SSH key to clipboard | Security |
| `genpass` | Generate secure password | Security |
| **macOS Specific** |
| `o`, `oo` | Open files/directories | macOS |
| `finder` | Open Finder | macOS |
| `copy`, `paste` | Clipboard operations | macOS |
| `ql` | Quick Look | macOS |
| **Cloud & Infrastructure** |
| `tf`, `tfi`, `tfp`, `tfa` | Terraform commands | Infrastructure |
| `tfd`, `tfv`, `tff` | Terraform destroy/validate/format | Infrastructure |
| `awsp`, `awswho` | AWS CLI operations | Cloud |
| `ap`, `av`, `ag` | Ansible commands | Infrastructure |
| **Productivity** |
| `weather`, `moon` | Weather information | Productivity |
| `please`, `pls`, `fucking` | sudo shortcuts | Productivity |
| `timer` | Simple timer | Productivity |
| `zshrc`, `zshreload` | Edit/reload .zshrc | Productivity |
| `hosts` | Edit /etc/hosts | Productivity |
| `gitconf` | Edit .gitconfig | Productivity |
| `editdots` | Edit dotfiles | Productivity |
| **IDE & Editors** |
| `code.`, `subl.`, `atom.` | IDE shortcuts | Development |
| `e`, `v` | Editor shortcuts | Development |
| **Media & Graphics** |
| `imgoptimize` | Image optimization | Media |
| `mp4towebm` | Video conversion | Media |
| **Utilities** |
| `p` | Print working directory | Utilities |
| `f` | Foreground job | Utilities |
| `k` | Kill process | Utilities |

## 📦 What Gets Installed

### Core System Components

| Component | Description | Purpose |
|-----------|-------------|---------|
| **ZSH** | Advanced shell with Oh My Zsh | Modern shell with extensive features |
| **Homebrew** | Package manager for macOS | Software installation and management |
| **Git** | Version control system | Source code management |
| **Oh My Zsh** | ZSH framework | Plugin management and themes |

### Essential Command Line Tools

| Tool | Purpose | Alternative to |
|------|---------|----------------|
| `ripgrep` | Fast text search | grep |
| `fd` | Fast file finder | find |
| `bat` | Enhanced cat | cat |
| `exa` | Modern ls | ls |
| `fzf` | Fuzzy finder | - |
| `htop` | Process monitor | top |
| `jq` | JSON processor | - |
| `tree` | Directory structure | - |

### Development Languages & Runtimes

| Language | Version | Package Manager | Purpose |
|----------|--------|----------------|---------|
| **Node.js** | Latest LTS | npm/yarn/pnpm | JavaScript/TypeScript |
| **Python** | 3.11+ | pip | General purpose |
| **Go** | Latest | go mod | Systems programming |
| **Rust** | Latest | cargo | Performance-critical |

### Development Tools & Utilities

| Category | Tools | Purpose |
|----------|-------|---------|
| **Containers** | Docker, Docker Compose, kubectl | Containerization & orchestration |
| **Databases** | MySQL, PostgreSQL, Redis, MongoDB | Data storage |
| **Cloud** | AWS CLI, Terraform, Ansible | Infrastructure & deployment |
| **Version Control** | GitHub CLI, Git LFS | Enhanced git workflows |
| **Text Processing** | GNU coreutils, sed, awk | Advanced text manipulation |

### GUI Applications (Optional)

| Application | Purpose | Category |
|-------------|---------|----------|
| **Visual Studio Code** | Code editor | Development |
| **iTerm2** | Terminal emulator | Productivity |
| **Docker Desktop** | Container management | Development |
| **Google Chrome** | Web browser | General |
| **Slack** | Team communication | Productivity |
| **Raycast** | Launcher & automation | Productivity |

## Configuration Structure

- `zsh/.zshrc` - Main shell configuration
- `zsh/aliases.zsh` - Command aliases
- `zsh/functions.zsh` - Custom functions
- `zsh/exports.zsh` - Environment variables
- `zsh/path.zsh` - PATH management
- `zsh/plugins.zsh` - Plugin configuration

## 🎨 Customization & Personalization

### Local Configuration

Create personal configuration files that won't be overwritten:

```bash
# Personal shell configuration
touch ~/.zshrc.local
echo "# Personal aliases" >> ~/.zshrc.local
echo "alias myalias='mycommand'" >> ~/.zshrc.local

# Personal git configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
```

### Environment Variables

Set personal environment variables in `~/.zshrc.local`:

```bash
# Development preferences
export EDITOR="code --wait"
export BROWSER="open"

# Personal paths
export MY_PROJECTS_DIR="$HOME/Projects"
export MY_NOTES_DIR="$HOME/Notes"
```

### Plugin Customization

Enable additional plugins based on your workflow:

```bash
# Enable syntax highlighting
export ENABLE_SYNTAX_HIGHLIGHTING="true"

# Enable autosuggestions
export ENABLE_AUTOSUGGESTIONS="true"

# Enable history search
export ENABLE_HISTORY_SEARCH="true"

# Reload configuration
source ~/.zshrc
```

### Theme Selection

Choose from available Oh My Zsh themes:

```bash
# Set theme in ~/.zshrc.local
export ZSH_THEME_OVERRIDE="agnoster"  # Popular theme
export ZSH_THEME_OVERRIDE="robbyrussell"  # Default theme
export ZSH_THEME_OVERRIDE="simple"  # Minimal theme
```

## ⚠️ Important Notes

- **macOS Only**: This setup is designed exclusively for macOS
- **Automatic Backups**: Existing configurations are backed up before changes
- **Admin Privileges**: Some operations require administrator access
- **Interactive Prompts**: The installer will ask for confirmation before changes
- **Rollback Support**: Use `make restore` to revert changes if needed

## 🤖 AI Integration (MCP Server)

This dotfiles setup includes an MCP (Model Context Protocol) server that allows AI agents to interact with and manage your dotfiles configuration.

### Features

- **Automated Management**: AI agents can install, update, and configure dotfiles
- **System Diagnostics**: Run health checks and performance benchmarks
- **Backup & Restore**: Create and restore configuration backups
- **Alias Management**: List and manage shell aliases programmatically
- **Testing**: Automated configuration validation

### Quick Setup

```bash
# Install MCP dependencies
pip install -r mcp/requirements.txt

# Test the server
python3 mcp/server.py
```

### Claude Desktop Integration

Add to your Claude Desktop configuration:

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

### Available MCP Tools

| Tool | Description |
|------|-------------|
| `install_dotfiles` | Install or update dotfiles |
| `backup_dotfiles` | Create configuration backup |
| `restore_dotfiles` | Restore from backup |
| `update_dotfiles` | Update dependencies |
| `test_dotfiles` | Run configuration tests |
| `doctor_dotfiles` | System diagnostics |
| `list_aliases` | List available aliases |
| `get_dotfiles_status` | Get current status |
| `clean_dotfiles` | Clean up broken links |
| `benchmark_shell` | Performance benchmark |

For detailed MCP documentation, see [mcp/README.md](mcp/README.md).

## 🔧 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Slow shell startup | Run `make benchmark` to identify bottlenecks |
| Plugin conflicts | Use `toggle_plugin <name> disable` to disable problematic plugins |
| Broken symlinks | Run `make clean` to remove broken links |
| Permission errors | Ensure you have admin privileges for system changes |
| MCP server errors | Check Python dependencies and file permissions |

### Getting Help

```bash
# System diagnostics
make doctor

# Check configuration validity
make test

# View installation log
cat ~/.dotfiles-install.log

# Check symlink status
make links

# Test MCP server
python3 mcp/server.py
```

## 🤝 Contributing

We welcome contributions! Here's how to get started:

### Development Setup

```bash
# Fork and clone the repository
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles

# Install development dependencies
make deps

# Run tests to ensure everything works
make test
```

### Contribution Guidelines

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Make** your changes with proper documentation
4. **Test** your changes (`make test`)
5. **Commit** with conventional commit format (`make commit`)
6. **Push** to your fork (`make push`)
7. **Submit** a pull request

### Code Standards

- Follow existing code style and patterns
- Add comprehensive documentation
- Include tests for new functionality
- Use conventional commit messages
- Ensure compatibility with both Apple Silicon and Intel Macs

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) - Amazing ZSH framework
- [Homebrew](https://brew.sh/) - The missing package manager for macOS
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast text search
- [bat](https://github.com/sharkdp/bat) - Enhanced cat with syntax highlighting
- [exa](https://github.com/ogham/exa) - Modern replacement for ls
- [fzf](https://github.com/junegunn/fzf) - Command-line fuzzy finder

## 📊 Statistics

- **200+** productivity aliases
- **50+** custom functions
- **30+** Oh My Zsh plugins
- **100+** Homebrew packages
- **Zero** configuration required
- **100%** macOS optimized

---

**Made with ❤️ for macOS developers**

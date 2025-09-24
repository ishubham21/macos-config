# 🚀 Professional Dotfiles

A modular, high-performance dotfiles setup for macOS. This configuration emphasizes productivity, maintainability, and extensibility.

## ✨ Features

- **Modular Architecture**: Organized into logical, maintainable components
- **Cross-Platform**: Works on macOS, Linux, and WSL
- **Performance Optimized**: Lazy loading, efficient startup times
- **Comprehensive Aliases**: 100+ productivity-boosting aliases
- **Advanced Functions**: Custom shell functions for development workflows
- **Automated Installation**: One-command setup for new machines
- **Plugin Management**: Smart Oh My Zsh plugin configuration
- **Development Tools**: Pre-configured for modern development stacks
- **Safe Installation**: Automatic backups before any changes

## 🏗️ Architecture

```
~/.dotfiles/
├── install.sh              # 🚀 Main installation script
├── Makefile                # 🔧 Build automation & maintenance
├── README.md               # 📚 This file
├── zsh/
│   ├── .zshrc              # 🎯 Main zsh configuration
│   ├── aliases.zsh         # 📋 Comprehensive aliases
│   ├── exports.zsh         # 🌍 Environment variables
│   ├── functions.zsh       # ⚡ Custom functions
│   ├── path.zsh           # 🛣️  PATH management
│   └── plugins.zsh        # 🔌 Plugin configuration
├── git/
│   ├── .gitconfig         # 📝 Git global configuration
│   └── .gitignore_global  # 🚫 Global gitignore patterns
├── scripts/
│   ├── setup_homebrew.sh  # 🍺 Homebrew setup
│   └── macos_defaults.sh  # 🍎 macOS system preferences
└── config/
    └── Brewfile           # 📦 Homebrew bundle file
```

## 🚀 Quick Start

### One-Line Installation

```bash
curl -sSL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh | bash
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run installation
./install.sh

# Or use Make for advanced options
make install
```

### Installation Options

```bash
# Force install (non-interactive)
./install.sh --force

# Skip package installation
./install.sh --skip-packages

# Dry run (see what would be installed)
./install.sh --dry-run

# Verbose output
./install.sh --verbose
```

## 🔧 Configuration

### Environment Variables

Set these in your local config to customize behavior:

```bash
# Enable enhanced plugins
export ENABLE_SYNTAX_HIGHLIGHTING=true
export ENABLE_AUTOSUGGESTIONS=true
export ENABLE_HISTORY_SEARCH=true

# Custom dotfiles repository
export DOTFILES_REPO="https://github.com/yourusername/dotfiles.git"

# Override theme
export ZSH_THEME_OVERRIDE="powerlevel10k/powerlevel10k"
```

### Local Customization

Create these files for local overrides (not version controlled):

- `~/.zshrc.local` - Local zsh configuration
- `~/.dotfiles/zsh/local.zsh` - Local dotfiles config
- `Makefile.local` - Local make targets

## 📋 Key Aliases & Functions

### Git Workflow
```bash
gs          # git status (short)
gd          # git diff
gc          # git commit
gca         # git commit -a
gcm         # git commit -m
gp          # git push
gpl         # git pull
gco         # git checkout
gcb         # git checkout -b
glog        # beautiful git log
```

### Development
```bash
# Node.js/npm
ni          # npm install
nr          # npm run
ns          # npm start
nb          # npm build

# Docker
d           # docker
dc          # docker-compose
dps         # docker ps
dprune      # docker system prune -af

# Kubernetes
k           # kubectl
kgp         # kubectl get pods
kgs         # kubectl get services
kd          # kubectl describe
```

### Navigation & Files
```bash
..          # cd ..
...         # cd ../..
ll          # ls -la (with exa if available)
la          # ls -A
mkcd        # mkdir and cd into it
extract     # extract any archive format
```

### System & Utilities
```bash
myip        # get external IP
weather     # weather forecast
sysinfo     # system information
psgrep      # search processes
portcheck   # check if port is open
```

## ⚡ Custom Functions

### Development Workflow
- `initproject <name> [type]` - Initialize new project (node/python/react/go)
- `gclone <repo>` - Clone and cd into repository
- `gconv <type> <message>` - Conventional commit format
- `benchmark <command>` - Benchmark command execution time

### System Administration
- `dnslookup <domain>` - Comprehensive DNS lookup
- `sslcheck <domain>` - Check SSL certificate
- `netscan [network]` - Network discovery scan
- `toggle_pinentry` - Switch GPG pinentry modes

### Productivity
- `note [text]` - Quick note taking system
- `todo add|list|done|remove` - Simple todo management
- `weather [location]` - Weather information
- `qr <text>` - Generate QR codes

## 🛠️ Development

### Make Commands

```bash
# Installation & Updates
make install              # Interactive installation
make install-force        # Non-interactive installation
make update               # Update dotfiles and dependencies

# Testing & Quality
make test                 # Run all tests
make lint                 # Lint shell scripts
make doctor               # System diagnostics
make benchmark            # Benchmark shell startup

# Maintenance
make backup               # Create backup
make clean                # Clean broken symlinks
make links                # Show all symlinks

# Git Operations
make commit               # Conventional commit
make push                 # Push changes
make pull                 # Pull updates
```

### Testing

```bash
# Test shell syntax
make test-syntax

# Test symlinks
make test-links

# Full test suite
make test
```

## 🔌 Plugin Management

### Enabled Plugins
- `git` - Git integration and aliases
- `docker` - Docker completions
- `node`/`npm` - Node.js ecosystem
- `kubectl` - Kubernetes completions
- `colored-man-pages` - Syntax highlighting for man pages

### Optional Plugins
Enable by setting environment variables:
- `zsh-syntax-highlighting` - Command syntax highlighting
- `zsh-autosuggestions` - Command autosuggestions
- `zsh-history-substring-search` - History search

### Plugin Functions
```bash
toggle_plugin <name> [enable|disable]  # Toggle plugins
list_plugins                           # List all plugins
suggest_plugins                        # Get recommendations
update_custom_plugins                  # Update custom plugins
```

## 🎨 Customization

### Themes
The default theme is `robbyrussell`. To change:

```bash
export ZSH_THEME_OVERRIDE="agnoster"
# or in ~/.zshrc.local
ZSH_THEME="powerlevel10k/powerlevel10k"
```

### Adding Custom Aliases
Create `~/.dotfiles/zsh/local.zsh`:

```bash
# Custom aliases
alias myalias='my command'

# Custom functions
myfunction() {
    echo "Hello $1"
}
```

## 🚨 Troubleshooting

### Common Issues

#### Slow Shell Startup
```bash
# Profile startup time
make benchmark

# Check for heavy plugins
ZSH_PLUGIN_DEBUG=true zsh
```

#### Broken Symlinks
```bash
# Clean broken links
make clean

# Check link status
make links
```

#### Missing Dependencies
```bash
# Install development dependencies
make deps

# Run system diagnostics
make doctor
```

### Performance Tuning

1. **Disable heavy plugins** in `plugins.zsh`
2. **Use lazy loading** for nvm, conda, etc.
3. **Limit history size** in `exports.zsh`
4. **Clean completion cache**: `rm ~/.zcompdump*`

## 🔒 Security Features

- **SSH Key Generation** - Automated ED25519 key creation
- **GPG Configuration** - Smart pinentry management
- **Secure Defaults** - Privacy-focused configurations
- **Backup System** - Safe installation with rollback

## 📱 Platform Support

### macOS
- Homebrew integration
- macOS-specific aliases
- System preference automation
- Clipboard integration

### Linux
- Multi-distro support (Ubuntu, Fedora, Arch)
- Package manager detection
- XDG Base Directory compliance

### Windows (WSL)
- WSL-specific optimizations
- Windows integration aliases
- Performance tuned for WSL

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** changes: `git commit -m 'feat: add amazing feature'`
4. **Push** to branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Development Setup

```bash
# Install development dependencies
make deps

# Run tests before committing
make test

# Use conventional commits
make commit
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework
- [Homebrew](https://brew.sh/) - macOS package manager
- Community dotfiles repositories for inspiration

## 📞 Support

- 📖 **Documentation**: Check the inline comments in config files
- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/dotfiles/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/dotfiles/discussions)

---

**Happy coding!** 🎉 If you find this useful, please ⭐ star the repository.
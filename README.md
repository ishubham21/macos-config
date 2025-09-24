# 🚀 Professional macOS Dotfiles

A senior engineer's modular, high-performance dotfiles setup for macOS. This configuration emphasizes productivity, maintainability, and extensibility.

## ✨ Features

- **macOS Optimized**: Tailored specifically for macOS with Homebrew package management
- **Modular Architecture**: Organized into logical, maintainable components
- **Performance Optimized**: Lazy loading, efficient startup times
- **Comprehensive Aliases**: 100+ productivity-boosting aliases
- **Advanced Functions**: Custom shell functions for development workflows
- **Automated Installation**: One-command setup for new Macs
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
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

## 📋 Requirements

- **macOS** (any recent version)
- **Git** (minimum requirement)
- **Internet connection** for package downloads

## 🛠️ Available Commands

```bash
make help              # Show all available commands
make install           # Interactive installation
make install-force     # Non-interactive installation
make update           # Update dotfiles and dependencies
make backup           # Backup current configuration
make doctor           # System diagnostics
make test             # Test configuration validity
make clean            # Clean up broken symlinks
```

## 📦 What Gets Installed

### Core Tools
- **Shell**: ZSH with Oh My Zsh framework
- **Package Manager**: Homebrew
- **Version Control**: Git

### Development Tools
- **Languages**: Node.js, Python 3, Go
- **Utilities**: curl, wget, tree, htop, jq
- **Search**: ripgrep, fd, fzf
- **File Tools**: bat, exa
- **Editors**: neovim
- **Terminal**: tmux

### Applications (Optional)
- **Code Editor**: Visual Studio Code
- **Terminal**: iTerm2
- **Browsers**: Firefox, Google Chrome
- **Containers**: Docker Desktop

## ⚙️ Configuration Structure

- `zsh/.zshrc` - Main shell configuration
- `zsh/aliases.zsh` - Command aliases
- `zsh/functions.zsh` - Custom functions
- `zsh/exports.zsh` - Environment variables
- `zsh/path.zsh` - PATH management
- `zsh/plugins.zsh` - Plugin configuration

## 🔧 Customization

After installation, customize your setup:

1. **Local Configuration**: Create `~/.zshrc.local` for personal settings
2. **Git Configuration**: Set your name and email
3. **SSH Keys**: Add your SSH keys to GitHub/GitLab
4. **macOS Settings**: Run `scripts/macos_defaults.sh` for system preferences

## 🚨 Important Notes

- This setup **only supports macOS**
- Existing configurations are automatically backed up
- Installation requires administrator privileges for some operations
- The script will prompt before making changes

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `make test`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

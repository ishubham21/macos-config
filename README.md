# macOS Dotfiles

A modular, high-performance dotfiles setup for macOS. This configuration emphasizes productivity, maintainability, and extensibility.

## Features

- **macOS Optimized**: Tailored specifically for macOS with Homebrew package management
- **Modular Architecture**: Organized into logical, maintainable components
- **Performance Optimized**: Lazy loading, efficient startup times
- **Comprehensive Aliases**: 100+ productivity-boosting aliases
- **Advanced Functions**: Custom shell functions for development workflows
- **Automated Installation**: One-command setup for new Macs
- **Plugin Management**: Smart Oh My Zsh plugin configuration
- **Development Tools**: Pre-configured for modern development stacks
- **Safe Installation**: Automatic backups before any changes

## Architecture

```
~/.dotfiles/
├── install.sh              # Main installation script
├── Makefile                # Build automation & maintenance
├── README.md               # This file
├── zsh/
│   ├── .zshrc              # Main zsh configuration
│   ├── aliases.zsh         # Comprehensive aliases
│   ├── exports.zsh         # Environment variables
│   ├── functions.zsh       # Custom functions
│   ├── path.zsh           # PATH management
│   └── plugins.zsh        # Plugin configuration
├── git/
│   ├── .gitconfig         # Git global configuration
│   └── .gitignore_global  # Global gitignore patterns
├── scripts/
│   ├── setup_homebrew.sh  # Homebrew setup
│   └── macos_defaults.sh  # macOS system preferences
└── config/
    └── Brewfile           # Homebrew bundle file
```

## Quick Start

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

## Requirements

- **macOS** (any recent version)
- **Git** (minimum requirement)
- **Internet connection** for package downloads

## Available Commands

### Make Commands
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

### Custom Commands & Aliases

| Command | Description | Category |
|---------|-------------|----------|
| **Navigation** |
| `..`, `...`, `....`, `.....` | Navigate up directories | Navigation |
| `~` | Go to home directory | Navigation |
| `-` | Go to previous directory | Navigation |
| `up()`, `up2()`, `up3()`, `up4()` | Navigate up directories | Navigation |
| `take()`, `mkcd()` | Create directory and enter it | Navigation |
| `www`, `dev`, `proj`, `repos` | Quick navigation to common directories | Navigation |
| `dotfiles`, `dots` | Navigate to dotfiles directory | Navigation |
| **File Operations** |
| `ls`, `ll`, `la`, `lt`, `ltr` | List files (with exa if available) | File Ops |
| `cp`, `mv`, `rm`, `ln` | Safe file operations with confirmation | File Ops |
| `mkdir`, `md` | Create directories with parents | File Ops |
| `extract()` | Extract various archive formats | File Ops |
| `tarzip`, `tarunzip` | Tar operations | File Ops |
| `findfile()`, `ff()` | Find files by name | File Ops |
| `finddir()`, `fd()` | Find directories | File Ops |
| `findopen()`, `fo()` | Find and open files | File Ops |
| `grepfiles()`, `grepf()` | Search in files | File Ops |
| **System Information** |
| `h`, `history` | Show command history | System |
| `j`, `jobs` | Show running jobs | System |
| `c`, `clear` | Clear terminal | System |
| `ps`, `psg` | Process information | System |
| `top`, `htop` | System monitoring | System |
| `topcpu()`, `topmem()` | Top CPU/memory processes | System |
| `dus()` | Disk usage summary | System |
| `sysinfo()` | System information | System |
| `meminfo()` | Memory usage by process | System |
| `psgrep()` | Search processes | System |
| **Network** |
| `ping` | Ping with 5 packets | Network |
| `myip`, `localip` | Get IP addresses | Network |
| `ipinfo()` | Get detailed IP information | Network |
| `portcheck()` | Check if port is open | Network |
| `killport()` | Kill process on port | Network |
| `netscan()` | Network scan | Network |
| `dnslookup()` | DNS lookup with multiple records | Network |
| `sslcheck()` | Check SSL certificate | Network |
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
| `gst()`, `gcb()`, `gcm()` | Git workflow functions | Git |
| `gps()`, `gpl()`, `gmerge()` | Git workflow functions | Git |
| `gri()`, `gstash()`, `gpop()` | Git workflow functions | Git |
| `glg()`, `gdiff()`, `gac()` | Git workflow functions | Git |
| `gclone()` | Clone and enter repository | Git |
| `gnb()` | Create new branch | Git |
| `gconv()` | Conventional commits | Git |
| **Development** |
| `ni`, `nis`, `nid`, `nig` | npm install variations | Node.js |
| `nt`, `nr`, `ns`, `nb` | npm run commands | Node.js |
| `nf` | npm audit fix | Node.js |
| `py`, `pip` | Python commands | Python |
| `venv`, `activate` | Virtual environment | Python |
| `dj`, `djr`, `djm` | Django commands | Python |
| `be`, `bi`, `bu` | Bundle/Ruby commands | Ruby |
| `serve()`, `serve8000`, `serve3000` | Start HTTP server | Web Dev |
| `port()` | Check port usage | Web Dev |
| **Docker** |
| `d`, `dc` | Docker commands | Docker |
| `dcu`, `dcd`, `dcl` | Docker Compose operations | Docker |
| `dps`, `dpsa` | Docker ps variations | Docker |
| `di`, `drmi` | Docker image operations | Docker |
| `dprune`, `dstop`, `drm` | Docker cleanup | Docker |
| `dexec()`, `dlogs()` | Docker helper functions | Docker |
| **Kubernetes** |
| `k` | kubectl command | Kubernetes |
| `kgp`, `kgs`, `kgd`, `kgn` | kubectl get operations | Kubernetes |
| `kd`, `kl`, `ke` | kubectl describe/logs/exec | Kubernetes |
| `kctx`, `kns` | kubectl context/namespace | Kubernetes |
| **Productivity** |
| `note()`, `n` | Note taking | Productivity |
| `todo()` | Todo management | Productivity |
| `weather()`, `weather` | Weather information | Productivity |
| `moon` | Moon phase | Productivity |
| `timer` | Simple timer | Productivity |
| `qr()` | Generate QR code | Productivity |
| `shorten()` | URL shortener | Productivity |
| `colors()` | Show color palette | Productivity |
| `benchmark()` | Benchmark commands | Productivity |
| `monitor()` | Monitor file changes | Productivity |
| `randstr()` | Generate random string | Productivity |
| `upper()`, `lower()` | Text case conversion | Productivity |
| `urlencode()`, `urldecode()` | URL encoding/decoding | Productivity |
| **macOS Specific** |
| `o`, `oo` | Open files/directories | macOS |
| `finder` | Open Finder | macOS |
| `copy`, `paste` | Clipboard operations | macOS |
| `ql` | Quick Look | macOS |
| `flushdns` | Flush DNS cache | macOS |
| `showfiles`, `hidefiles` | Toggle hidden files | macOS |
| `osupdate` | macOS system update | macOS |
| `hidedesktop`, `showdesktop` | Toggle desktop icons | macOS |
| `dsclean` | Remove .DS_Store files | macOS |
| `xcclean` | Clean Xcode derived data | macOS |
| `togglehidden()` | Toggle hidden files in Finder | macOS |
| `bundleid()` | Get app bundle ID | macOS |
| `ejectall()` | Eject all volumes | macOS |
| `lock()` | Lock screen | macOS |
| **Security** |
| `gensshkey()` | Generate SSH key | Security |
| `sshconfig`, `sshconf` | Edit SSH config | Security |
| `sshkey` | Copy SSH key to clipboard | Security |
| `genpass` | Generate secure password | Security |
| `toggle_pinentry()` | Toggle GPG pinentry | Security |
| **Configuration** |
| `zshrc` | Edit .zshrc | Config |
| `zshreload` | Reload .zshrc | Config |
| `hosts` | Edit /etc/hosts | Config |
| `gitconf` | Edit .gitconfig | Config |
| `editdots` | Edit dotfiles | Config |
| **Project Management** |
| `newproject()`, `createproject()` | Create new project | Projects |
| `initproject()` | Initialize project with templates | Projects |
| `nodemodclean` | Remove node_modules | Projects |
| **Utilities** |
| `please`, `pls`, `fucking` | sudo shortcuts | Utilities |
| `chrome`, `firefox`, `safari` | Browser shortcuts | Utilities |
| `code.`, `subl.`, `atom.` | IDE shortcuts | Utilities |
| `e`, `v` | Editor shortcuts | Utilities |
| `p` | Print working directory | Utilities |
| `f` | Foreground job | Utilities |
| `k` | Kill process | Utilities |

## What Gets Installed

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

## Configuration Structure

- `zsh/.zshrc` - Main shell configuration
- `zsh/aliases.zsh` - Command aliases
- `zsh/functions.zsh` - Custom functions
- `zsh/exports.zsh` - Environment variables
- `zsh/path.zsh` - PATH management
- `zsh/plugins.zsh` - Plugin configuration

## Customization

After installation, customize your setup:

1. **Local Configuration**: Create `~/.zshrc.local` for personal settings
2. **Git Configuration**: Set your name and email
3. **SSH Keys**: Add your SSH keys to GitHub/GitLab
4. **macOS Settings**: Run `scripts/macos_defaults.sh` for system preferences

## Important Notes

- This setup **only supports macOS**
- Existing configurations are automatically backed up
- Installation requires administrator privileges for some operations
- The script will prompt before making changes

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `make test`
5. Submit a pull request

## License

This project is licensed under the MIT License.

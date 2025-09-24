#!/usr/bin/env bash

set -euo pipefail

readonly DOTFILES_DIR="$HOME/.dotfiles"
readonly DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/yourusername/dotfiles.git}"
readonly BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
readonly LOG_FILE="$HOME/.dotfiles-install.log"

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[0;37m'
readonly NC='\033[0m'

FORCE_INSTALL=false
SKIP_PACKAGES=false
DRY_RUN=false
VERBOSE=false

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "$LOG_FILE" >&2
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" | tee -a "$LOG_FILE" >&2
}

info() {
    echo -e "${BLUE}[INFO]${NC} $*" | tee -a "$LOG_FILE"
}

debug() {
    [[ "$VERBOSE" == true ]] && echo -e "${PURPLE}[DEBUG]${NC} $*" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" | tee -a "$LOG_FILE"
}

has_command() {
    command -v "$1" >/dev/null 2>&1
}

confirm() {
    local message="$1"
    local default="${2:-n}"
    
    if [[ "$FORCE_INSTALL" == true ]]; then
        return 0
    fi
    
    while true; do
        if [[ "$default" == "y" ]]; then
            read -p "$message [Y/n]: " -n 1 -r
        else
            read -p "$message [y/N]: " -n 1 -r
        fi
        echo
        
        case "$REPLY" in
            [Yy]|"") [[ "$default" == "y" ]] && return 0 || return 1 ;;
            [Nn]|"") [[ "$default" == "n" ]] && return 1 || return 0 ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
}

backup_file() {
    local file="$1"
    
    if [[ -e "$file" && ! -L "$file" ]]; then
        [[ ! -d "$BACKUP_DIR" ]] && mkdir -p "$BACKUP_DIR"
        cp "$file" "$BACKUP_DIR/$(basename "$file")"
        info "Backed up $file to $BACKUP_DIR"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ "$DRY_RUN" == true ]]; then
        info "[DRY RUN] Would create symlink: $target -> $source"
        return 0
    fi
    
    backup_file "$target"
    
    [[ -e "$target" || -L "$target" ]] && rm -f "$target"
    
    local target_dir
    target_dir=$(dirname "$target")
    [[ ! -d "$target_dir" ]] && mkdir -p "$target_dir"
    
    ln -sf "$source" "$target"
    success "Created symlink: $target -> $source"
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unsupported"
    fi
}

install_homebrew() {
    if ! has_command brew; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        if [[ -d "/opt/homebrew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        info "Homebrew already installed"
    fi
}

install_oh_my_zsh() {
    local oh_my_zsh_dir="$HOME/.oh-my-zsh"
    
    if [[ ! -d "$oh_my_zsh_dir" ]]; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        info "Oh My Zsh already installed"
    fi
}

install_packages_macos() {
    if [[ "$SKIP_PACKAGES" == true ]]; then
        info "Skipping package installation"
        return 0
    fi
    
    install_homebrew
    
    info "Installing macOS packages via Homebrew..."
    
    local packages=(
        git
        zsh
        curl
        wget
        tree
        htop
        jq
        ripgrep
        fd
        bat
        exa
        fzf
        neovim
        tmux
        node
        python3
        go
        docker
        docker-compose
    )
    
    for package in "${packages[@]}"; do
        if brew list "$package" &>/dev/null; then
            debug "$package already installed"
        else
            info "Installing $package..."
            brew install "$package" || warn "Failed to install $package"
        fi
    done
    
    local casks=(
        visual-studio-code
        iterm2
        docker
        firefox
        google-chrome
    )
    
    if confirm "Install GUI applications via Homebrew Cask?"; then
        for cask in "${casks[@]}"; do
            if brew list --cask "$cask" &>/dev/null; then
                debug "$cask already installed"
            else
                info "Installing $cask..."
                brew install --cask "$cask" || warn "Failed to install $cask"
            fi
        done
    fi
}

clone_dotfiles() {
    if [[ -d "$DOTFILES_DIR" ]]; then
        if [[ -d "$DOTFILES_DIR/.git" ]]; then
            info "Dotfiles repository already exists"
            cd "$DOTFILES_DIR"
            
            if git remote get-url origin >/dev/null 2>&1; then
                info "Updating from remote repository..."
                git pull origin main || git pull origin master
            else
                warn "No remote origin configured - skipping update"
                info "To set up remote: git remote add origin <your-repo-url>"
            fi
        else
            warn "Dotfiles directory exists but is not a git repository"
            if confirm "Remove existing directory and clone fresh?"; then
                rm -rf "$DOTFILES_DIR"
                git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
            else
                error "Cannot proceed without removing existing directory"
                exit 1
            fi
        fi
    else
        info "Cloning dotfiles repository..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
}

setup_symlinks() {
    info "Setting up symlinks..."
    
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    
    [[ -f "$DOTFILES_DIR/git/.gitconfig" ]] && \
        create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    
    [[ -f "$DOTFILES_DIR/git/.gitignore_global" ]] && \
        create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
    
    [[ -f "$DOTFILES_DIR/vim/.vimrc" ]] && \
        create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
    
    [[ -f "$DOTFILES_DIR/ssh/config" ]] && \
        create_symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
}

configure_shell() {
    if [[ "$SHELL" != *"zsh" ]]; then
        info "Setting zsh as default shell..."
        
        local zsh_path
        if has_command zsh; then
            zsh_path=$(which zsh)
            
            if ! grep -q "$zsh_path" /etc/shells; then
                echo "$zsh_path" | sudo tee -a /etc/shells
            fi
            
            chsh -s "$zsh_path"
            success "Default shell changed to zsh"
        else
            warn "zsh not found, cannot set as default shell"
        fi
    fi
}

setup_directories() {
    info "Creating useful directories..."
    
    local dirs=(
        "$HOME/Development"
        "$HOME/Projects"
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/notes"
    )
    
    for dir in "${dirs[@]}"; do
        [[ ! -d "$dir" ]] && mkdir -p "$dir" && info "Created directory: $dir"
    done
}

generate_ssh_key() {
    if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
        if confirm "Generate SSH key?"; then
            info "Generating SSH key..."
            read -p "Enter your email for SSH key: " email
            ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
            
            info "SSH key generated. Add this public key to your Git providers:"
            cat "$HOME/.ssh/id_ed25519.pub"
            
            if [[ "$OSTYPE" == "darwin"* ]]; then
                pbcopy < "$HOME/.ssh/id_ed25519.pub"
                success "Public key copied to clipboard"
            fi
        fi
    fi
}

show_usage() {
    cat << EOF
Dotfiles Installation Script

Usage: $0 [OPTIONS]

Options:
    -f, --force         Force installation without prompts
    -s, --skip-packages Skip package installation
    -d, --dry-run       Show what would be done without doing it
    -v, --verbose       Enable verbose output
    -h, --help          Show this help message

Environment Variables:
    DOTFILES_REPO       Git repository URL for dotfiles
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--force)
                FORCE_INSTALL=true
                shift
                ;;
            -s|--skip-packages)
                SKIP_PACKAGES=true
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

main() {
    parse_args "$@"
    
    : > "$LOG_FILE"
    
    info "Starting dotfiles installation..."
    info "OS: $(detect_os)"
    info "Log file: $LOG_FILE"
    
    if [[ "$DRY_RUN" == true ]]; then
        warn "DRY RUN MODE - No changes will be made"
    fi
    
    if ! has_command git; then
        error "Git is required but not installed"
        exit 1
    fi
    
    clone_dotfiles
    
    case "$(detect_os)" in
        macos)
            install_packages_macos
            ;;
        *)
            error "This dotfiles setup only supports macOS"
            error "Detected OS: $OSTYPE"
            exit 1
            ;;
    esac
    
    install_oh_my_zsh
    setup_symlinks
    setup_directories
    configure_shell
    generate_ssh_key
    
    success "Dotfiles installation completed!"
    info "Backup created at: $BACKUP_DIR"
    info "Installation log: $LOG_FILE"
    
    echo -e "\n${CYAN}Next steps:${NC}"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Configure git: git config --global user.name 'Your Name'"
    echo "3. Configure git: git config --global user.email 'your.email@example.com'"
    echo "4. Review and customize your dotfiles in $DOTFILES_DIR"
    
    if [[ -f "$HOME/.ssh/id_ed25519.pub" ]]; then
        echo "5. Add your SSH key to GitHub/GitLab/etc."
    fi
}

main "$@"
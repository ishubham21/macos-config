#!/usr/bin/env bash
# =============================================================================
# setup_homebrew.sh - Homebrew Installation and Setup
# =============================================================================
# Description: Installs Homebrew and sets up the environment
# =============================================================================

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

# Check if command exists
has_command() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew
install_homebrew() {
    if has_command brew; then
        info "Homebrew already installed"
        brew --version
        return 0
    fi
    
    info "Installing Homebrew..."
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -d "/opt/homebrew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        success "Added Homebrew to PATH for Apple Silicon"
    elif [[ -d "/usr/local/homebrew" ]]; then
        eval "$(/usr/local/homebrew/bin/brew shellenv)"
        echo 'eval "$(/usr/local/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        success "Added Homebrew to PATH for Intel Mac"
    fi
    
    success "Homebrew installation completed"
}

# Update Homebrew
update_homebrew() {
    info "Updating Homebrew..."
    brew update
    brew upgrade
    success "Homebrew updated"
}

# Install packages from Brewfile
install_packages() {
    local brewfile_path="${1:-$HOME/.dotfiles/config/Brewfile}"
    
    if [[ ! -f "$brewfile_path" ]]; then
        error "Brewfile not found at: $brewfile_path"
        return 1
    fi
    
    info "Installing packages from Brewfile..."
    brew bundle --file="$brewfile_path"
    success "Packages installed from Brewfile"
}

# Clean up Homebrew
cleanup_homebrew() {
    info "Cleaning up Homebrew..."
    brew cleanup
    brew doctor
    success "Homebrew cleanup completed"
}

# Main function
main() {
    log "Starting Homebrew setup..."
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "This script only supports macOS"
        exit 1
    fi
    
    # Install Homebrew
    install_homebrew
    
    # Update Homebrew
    update_homebrew
    
    # Install packages if Brewfile exists
    if [[ -f "$HOME/.dotfiles/config/Brewfile" ]]; then
        install_packages "$HOME/.dotfiles/config/Brewfile"
    else
        warn "No Brewfile found, skipping package installation"
    fi
    
    # Clean up
    cleanup_homebrew
    
    success "Homebrew setup completed!"
    
    echo -e "\n${BLUE}Next steps:${NC}"
    echo "1. Restart your terminal or run: source ~/.zprofile"
    echo "2. Verify installation: brew doctor"
    echo "3. Install additional packages: brew install <package>"
}

# Run main function
main "$@"

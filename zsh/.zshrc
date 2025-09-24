#!/usr/bin/env zsh
# =============================================================================
# .zshrc - Main ZSH Configuration
# =============================================================================
# Author: Senior Engineer Setup
# Description: Modular, high-performance ZSH configuration
# =============================================================================

# Performance monitoring (optional - comment out in production)
# zmodload zsh/zprof

# =============================================================================
# Core Configuration
# =============================================================================

# Set dotfiles directory
export DOTFILES="$HOME/.dotfiles"

# Ensure dotfiles directory exists
if [[ ! -d "$DOTFILES" ]]; then
    echo "⚠️  Dotfiles directory not found at $DOTFILES"
    echo "   Please run the installation script first."
    return 1
fi

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Performance settings
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

# Update behavior
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 30

# Enable command correction with caution
ENABLE_CORRECTION="false"  # Can be annoying for power users

# =============================================================================
# Plugin Management
# =============================================================================

# Load plugin configuration
source "$DOTFILES/zsh/plugins.zsh"

# Initialize Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# Load Modular Configurations
# =============================================================================

# Load configurations in order of dependency
config_files=(
    "$DOTFILES/zsh/exports.zsh"    # Environment variables first
    "$DOTFILES/zsh/path.zsh"       # PATH configuration
    "$DOTFILES/zsh/aliases.zsh"    # Aliases
    "$DOTFILES/zsh/functions.zsh"  # Custom functions
)

# Load each configuration file with error handling
for config_file in "${config_files[@]}"; do
    if [[ -f "$config_file" ]]; then
        source "$config_file"
    else
        echo "⚠️  Configuration file not found: $config_file"
    fi
done

# =============================================================================
# Local Customizations
# =============================================================================

# Load machine-specific configurations (not version controlled)
local_configs=(
    "$HOME/.zshrc.local"           # Local overrides
    "$HOME/.zsh.local"             # Alternative local config
    "$DOTFILES/zsh/local.zsh"      # Local dotfiles config
)

for local_config in "${local_configs[@]}"; do
    [[ -f "$local_config" ]] && source "$local_config"
done

# =============================================================================
# Terminal Integration
# =============================================================================

# iTerm2 shell integration
[[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# =============================================================================
# Performance Monitoring (Development)
# =============================================================================

# Uncomment for startup time analysis
# zprof

# =============================================================================
# Startup Message (Optional)
# =============================================================================

# Display system info on new terminal (comment out if annoying)
if [[ "$SHLVL" -eq 1 ]] && [[ -n "$PS1" ]]; then
    echo "🚀 $(hostname) | $(date '+%Y-%m-%d %H:%M:%S') | ZSH $(zsh --version | cut -d' ' -f2)"
fi
#!/usr/bin/env zsh
# =============================================================================
# exports.zsh - Environment Variables Configuration
# =============================================================================

# =============================================================================
# System Locale
# =============================================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# =============================================================================
# Editor Configuration
# =============================================================================
if command -v code >/dev/null 2>&1; then
    export EDITOR='code --wait'
    export GIT_EDITOR='code --wait'
elif command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
    export GIT_EDITOR='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR='vim'
    export GIT_EDITOR='vim'
else
    export EDITOR='nano'
    export GIT_EDITOR='nano'
fi

# Visual editor for crontab, etc.
export VISUAL="$EDITOR"

# =============================================================================
# Pager Configuration
# =============================================================================
export PAGER='less'
export MANPAGER='less'
export LESS='-R -i -w -M -z-4'

# =============================================================================
# History Configuration
# =============================================================================
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="$HOME/.zsh_history"

# History options
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry
setopt HIST_VERIFY               # Don't execute immediately upon history expansion

# =============================================================================
# Development Environment
# =============================================================================

# Node.js
export NODE_OPTIONS="--max-old-space-size=8192"
export NPM_CONFIG_PROGRESS=false

# Python
export PYTHONDONTWRITEBYTECODE=1
export PIP_REQUIRE_VIRTUALENV=false

# Go
if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/go"
    export GOOS="$(go env GOOS 2>/dev/null || echo 'unknown')"
    export GOARCH="$(go env GOARCH 2>/dev/null || echo 'unknown')"
fi

# Rust
if [[ -d "$HOME/.cargo" ]]; then
    export CARGO_HOME="$HOME/.cargo"
fi

# Java
if [[ -d "/opt/homebrew/opt/openjdk@17" ]]; then
    export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
elif [[ -d "/usr/libexec/java_home" ]] && /usr/libexec/java_home >/dev/null 2>&1; then
    export JAVA_HOME="$(/usr/libexec/java_home)"
fi

# Android
if [[ -d "$HOME/Library/Android/sdk" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
fi

# =============================================================================
# Security & GPG
# =============================================================================
export GPG_TTY=$(tty)

# SSH
export SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

# =============================================================================
# Package Managers
# =============================================================================

# Homebrew
if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
    export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

# pnpm
if [[ -d "$HOME/Library/pnpm" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
fi

# =============================================================================
# Performance & Optimization
# =============================================================================

# Disable globe verification for performance
setopt NO_GLOB_DOTS

# Completion configuration
autoload -Uz compinit

# Only check for new completions once per day
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
    compinit -d ~/.zcompdump
else
    compinit -C -d ~/.zcompdump
fi

# =============================================================================
# Application-Specific
# =============================================================================

# Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Kubernetes
if command -v kubectl >/dev/null 2>&1; then
    export KUBE_EDITOR="$EDITOR"
fi

# Terraform
if command -v terraform >/dev/null 2>&1; then
    export TF_CLI_ARGS_plan="-parallelism=10"
    export TF_CLI_ARGS_apply="-parallelism=10"
fi

# AWS
export AWS_PAGER=""

# =============================================================================
# XDG Base Directory Specification
# =============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# =============================================================================
# Cleanup
# =============================================================================

# Less history file
export LESSHISTFILE="/dev/null"

# MySQL history
export MYSQL_HISTFILE="/dev/null"
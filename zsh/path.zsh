#!/usr/bin/env zsh
# =============================================================================
# path.zsh - PATH Management Configuration
# =============================================================================

# =============================================================================
# PATH Helper Functions
# =============================================================================

# Function to add directory to PATH if it exists and isn't already there
add_to_path() {
    local dir="$1"
    local position="${2:-end}"  # 'start' or 'end', defaults to 'end'
    
    # Check if directory exists
    if [[ ! -d "$dir" ]]; then
        return 1
    fi
    
    # Check if already in PATH
    case ":$PATH:" in
        *":$dir:"*) return 0 ;;
    esac
    
    # Add to PATH
    if [[ "$position" == "start" ]]; then
        export PATH="$dir:$PATH"
    else
        export PATH="$PATH:$dir"
    fi
}

# Function to remove directory from PATH
remove_from_path() {
    local dir="$1"
    PATH=$(echo "$PATH" | sed -e "s|:$dir||g" -e "s|$dir:||g" -e "s|$dir||g")
    export PATH
}

# Function to clean up PATH (remove empty entries and duplicates)
clean_path() {
    local new_path=""
    local dir
    
    # Split PATH and rebuild without duplicates
    for dir in $(echo "$PATH" | tr ':' '\n'); do
        if [[ -n "$dir" && -d "$dir" ]]; then
            case ":$new_path:" in
                *":$dir:"*) ;;  # Skip if already in new_path
                *) new_path="$new_path:$dir" ;;
            esac
        fi
    done
    
    # Remove leading colon
    export PATH="${new_path#:}"
}

# =============================================================================
# System Paths (Highest Priority)
# =============================================================================

# Local user binaries (highest priority)
add_to_path "$HOME/.local/bin" start
add_to_path "$HOME/bin" start

# =============================================================================
# Package Manager Paths
# =============================================================================

# Homebrew (macOS)
if [[ "$OSTYPE" == darwin* ]]; then
    # Apple Silicon Macs
    if [[ -d "/opt/homebrew" ]]; then
        add_to_path "/opt/homebrew/bin" start
        add_to_path "/opt/homebrew/sbin" start
    fi
    
    # Intel Macs
    if [[ -d "/usr/local/homebrew" ]]; then
        add_to_path "/usr/local/homebrew/bin" start
        add_to_path "/usr/local/homebrew/sbin" start
    fi
fi


# =============================================================================
# Language-Specific Paths
# =============================================================================

# Node.js (via Homebrew)
add_to_path "/opt/homebrew/opt/node@20/bin"
add_to_path "/opt/homebrew/opt/node@18/bin"

# Python
if command -v python3 >/dev/null 2>&1; then
    PYTHON_USER_BASE=$(python3 -m site --user-base 2>/dev/null)
    if [[ -n "$PYTHON_USER_BASE" ]]; then
        add_to_path "$PYTHON_USER_BASE/bin"
    fi
fi

# Ruby (via Homebrew)
add_to_path "/opt/homebrew/opt/ruby/bin"
if [[ -d "/opt/homebrew/lib/ruby/gems" ]]; then
    for ruby_version in /opt/homebrew/lib/ruby/gems/*/bin; do
        [[ -d "$ruby_version" ]] && add_to_path "$ruby_version"
    done
fi

# Go
if [[ -n "$GOPATH" ]]; then
    add_to_path "$GOPATH/bin"
fi

# Rust
add_to_path "$HOME/.cargo/bin"

# Java
add_to_path "/opt/homebrew/opt/openjdk@17/bin"
add_to_path "/opt/homebrew/opt/openjdk@11/bin"
add_to_path "/opt/homebrew/opt/openjdk@8/bin"

# =============================================================================
# Development Tools
# =============================================================================

# Android SDK
if [[ -n "$ANDROID_HOME" ]]; then
    add_to_path "$ANDROID_HOME/emulator"
    add_to_path "$ANDROID_HOME/tools"
    add_to_path "$ANDROID_HOME/tools/bin"
    add_to_path "$ANDROID_HOME/platform-tools"
fi

# Flutter
add_to_path "$HOME/flutter/bin"
add_to_path "/opt/homebrew/opt/flutter/bin"

# Docker Desktop (macOS)
add_to_path "/Applications/Docker.app/Contents/Resources/bin"

# =============================================================================
# IDE and Editors
# =============================================================================

# JetBrains IDEs
add_to_path "/Applications/WebStorm.app/Contents/MacOS"
add_to_path "/Applications/IntelliJ IDEA.app/Contents/MacOS"
add_to_path "/Applications/PyCharm.app/Contents/MacOS"
add_to_path "/Applications/PhpStorm.app/Contents/MacOS"

# Visual Studio Code
if [[ "$OSTYPE" == darwin* ]]; then
    add_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# Sublime Text
if [[ "$OSTYPE" == darwin* ]]; then
    add_to_path "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
fi

# =============================================================================
# Package Manager Executables
# =============================================================================

# pnpm
if [[ -n "$PNPM_HOME" ]]; then
    case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi

# Yarn (global)
add_to_path "$HOME/.yarn/bin"
add_to_path "$HOME/.config/yarn/global/node_modules/.bin"

# npm global packages
if command -v npm >/dev/null 2>&1; then
    NPM_GLOBAL_PREFIX=$(npm config get prefix 2>/dev/null)
    if [[ -n "$NPM_GLOBAL_PREFIX" && "$NPM_GLOBAL_PREFIX" != "undefined" ]]; then
        add_to_path "$NPM_GLOBAL_PREFIX/bin"
    fi
fi

# =============================================================================
# Lazy Loading Setups
# =============================================================================

# NVM lazy loading function
setup_nvm_lazy() {
    export NVM_DIR="$HOME/.nvm"
    
    # Create lazy loading function
    load_nvm() {
        unset -f nvm node npm npx
        if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
            source "/opt/homebrew/opt/nvm/nvm.sh"
        elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
            source "$NVM_DIR/nvm.sh"
        fi
        
        # Load bash completion
        if [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]]; then
            source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
        elif [[ -s "$NVM_DIR/bash_completion" ]]; then
            source "$NVM_DIR/bash_completion"
        fi
    }
    
    # Create lazy loading aliases
    nvm() {
        load_nvm
        nvm "$@"
    }
    
    node() {
        load_nvm
        node "$@"
    }
    
    npm() {
        load_nvm
        npm "$@"
    }
    
    npx() {
        load_nvm
        npx "$@"
    }
}

# Enable NVM lazy loading
setup_nvm_lazy

# =============================================================================
# Conda Setup (If Installed)
# =============================================================================

# >>> conda initialize >>>
if [[ -f "$HOME/miniconda3/bin/conda" ]]; then
    __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            source "$HOME/miniconda3/etc/profile.d/conda.sh"
        else
            add_to_path "$HOME/miniconda3/bin"
        fi
    fi
    unset __conda_setup
fi
# <<< conda initialize <<<

# =============================================================================
# System-Specific Paths
# =============================================================================

# macOS specific
if [[ "$OSTYPE" == darwin* ]]; then
    # MacTeX
    add_to_path "/usr/local/texlive/2023/bin/universal-darwin"
    add_to_path "/usr/local/texlive/2022/bin/universal-darwin"
    
    # PostgreSQL (via Homebrew)
    add_to_path "/opt/homebrew/opt/postgresql@14/bin"
    add_to_path "/opt/homebrew/opt/postgresql@13/bin"
    
    # MySQL (via Homebrew)
    add_to_path "/opt/homebrew/opt/mysql@8.0/bin"
    add_to_path "/opt/homebrew/opt/mysql@5.7/bin"
fi


# =============================================================================
# Final Cleanup
# =============================================================================

# Clean up PATH by removing duplicates and empty entries
clean_path

# Unset helper functions to keep namespace clean
unset -f add_to_path remove_from_path clean_path setup_nvm_lazy
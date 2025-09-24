#!/usr/bin/env zsh
# =============================================================================
# plugins.zsh - Plugin Configuration
# =============================================================================

# =============================================================================
# Oh My Zsh Plugin List
# =============================================================================

# Core plugins (practical and useful)
plugins=(
    git                    # Git integration and aliases
    git-flow              # Git flow commands
    docker                # Docker completions
    kubectl               # Kubernetes completions
    node                  # Node.js completions
    npm                   # npm completions
    colored-man-pages     # Colorized man pages
    command-not-found     # Suggests packages for missing commands
    sudo                  # ESC ESC to add sudo
    copypath              # Copy current path
    copyfile              # Copy file contents
    jsontools             # JSON manipulation tools
    web-search            # Web search from terminal
    extract               # Extract archives
    history               # Enhanced history
    last-working-dir      # Remember last directory
    z                     # Smart directory jumping
    macos                 # macOS specific commands
    brew                  # Homebrew integration
    python                # Python completions
    golang                # Go completions
    aws                   # AWS CLI completions
    terraform             # Terraform completions
)

# =============================================================================
# Conditional Plugin Loading
# =============================================================================

# Add plugins based on available tools
if command -v aws >/dev/null 2>&1; then
    plugins+=(aws)
fi

if command -v terraform >/dev/null 2>&1; then
    plugins+=(terraform)
fi

if command -v ansible >/dev/null 2>&1; then
    plugins+=(ansible)
fi

if command -v pip >/dev/null 2>&1; then
    plugins+=(pip)
fi

if command -v yarn >/dev/null 2>&1; then
    plugins+=(yarn)
fi

if command -v brew >/dev/null 2>&1; then
    plugins+=(brew)
fi

# macOS specific plugins
if [[ "$OSTYPE" == darwin* ]]; then
    plugins+=(
        macos              # macOS specific aliases
        xcode             # Xcode utilities
    )
fi

# =============================================================================
# Custom Plugin Installation Check
# =============================================================================

# Check and install custom plugins if they don't exist
ZSH_CUSTOM_PLUGINS="$ZSH/custom/plugins"

# Function to install plugin if not exists
install_plugin_if_missing() {
    local plugin_name="$1"
    local plugin_repo="$2"
    local plugin_dir="$ZSH_CUSTOM_PLUGINS/$plugin_name"
    
    if [[ ! -d "$plugin_dir" ]]; then
        echo "📦 Installing $plugin_name plugin..."
        git clone "$plugin_repo" "$plugin_dir" --quiet
        if [[ $? -eq 0 ]]; then
            echo "✅ $plugin_name installed successfully"
        else
            echo "❌ Failed to install $plugin_name"
            return 1
        fi
    fi
    return 0
}

# =============================================================================
# Optional Enhanced Plugins
# =============================================================================

# Syntax highlighting (install if requested)
if [[ "$ENABLE_SYNTAX_HIGHLIGHTING" == "true" ]]; then
    if install_plugin_if_missing "zsh-syntax-highlighting" \
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"; then
        plugins+=(zsh-syntax-highlighting)
    fi
fi

# Autosuggestions (install if requested)
if [[ "$ENABLE_AUTOSUGGESTIONS" == "true" ]]; then
    if install_plugin_if_missing "zsh-autosuggestions" \
        "https://github.com/zsh-users/zsh-autosuggestions.git"; then
        plugins+=(zsh-autosuggestions)
        
        # Configuration for autosuggestions
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    fi
fi

# History substring search (install if requested)
if [[ "$ENABLE_HISTORY_SEARCH" == "true" ]]; then
    if install_plugin_if_missing "zsh-history-substring-search" \
        "https://github.com/zsh-users/zsh-history-substring-search.git"; then
        plugins+=(zsh-history-substring-search)
        
        # Configuration for history substring search
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=white,bold'
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
        HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
    fi
fi

# Fast syntax highlighting (alternative to zsh-syntax-highlighting)
if [[ "$ENABLE_FAST_HIGHLIGHTING" == "true" ]]; then
    if install_plugin_if_missing "fast-syntax-highlighting" \
        "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"; then
        plugins+=(fast-syntax-highlighting)
    fi
fi

# You Should Use (reminds you to use aliases)
if [[ "$ENABLE_YOU_SHOULD_USE" == "true" ]]; then
    if install_plugin_if_missing "you-should-use" \
        "https://github.com/MichaelAquilina/zsh-you-should-use.git"; then
        plugins+=(you-should-use)
        
        # Configuration
        export YSU_MESSAGE_POSITION="after"
        export YSU_HARDCORE=1
    fi
fi

# =============================================================================
# Plugin Configuration
# =============================================================================

# Git plugin configuration
if (( ${plugins[(Ie)git]} )); then
    # Disable git aliases that conflict with our custom ones
    zstyle ':omz:plugins:git' aliases no
fi

# Docker plugin configuration
if (( ${plugins[(Ie)docker]} )); then
    # Docker compose alias preference
    zstyle ':omz:plugins:docker' legacy-compose yes
fi

# Kubectl plugin configuration
if (( ${plugins[(Ie)kubectl]} )); then
    # Auto-completion for kubectl
    autoload -Uz compinit && compinit
fi

# =============================================================================
# Theme Configuration
# =============================================================================

# Set theme based on preference
if [[ -n "$ZSH_THEME_OVERRIDE" ]]; then
    ZSH_THEME="$ZSH_THEME_OVERRIDE"
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    # Enhanced theme for iTerm2
    ZSH_THEME="agnoster"
elif command -v git >/dev/null 2>&1; then
    # Git-aware theme
    ZSH_THEME="robbyrussell"
else
    # Minimal theme
    ZSH_THEME="simple"
fi

# =============================================================================
# Advanced Plugin Management
# =============================================================================

# Function to enable/disable plugins dynamically
toggle_plugin() {
    local plugin="$1"
    local action="${2:-toggle}"
    
    case "$action" in
        enable)
            if (( ! ${plugins[(Ie)$plugin]} )); then
                plugins+=($plugin)
                echo "✅ Plugin '$plugin' enabled. Reload shell to take effect."
            else
                echo "⚠️  Plugin '$plugin' is already enabled."
            fi
            ;;
        disable)
            if (( ${plugins[(Ie)$plugin]} )); then
                plugins=("${plugins[@]/$plugin}")
                echo "❌ Plugin '$plugin' disabled. Reload shell to take effect."
            else
                echo "⚠️  Plugin '$plugin' is not currently enabled."
            fi
            ;;
        toggle)
            if (( ${plugins[(Ie)$plugin]} )); then
                toggle_plugin "$plugin" disable
            else
                toggle_plugin "$plugin" enable
            fi
            ;;
        *)
            echo "Usage: toggle_plugin <plugin> [enable|disable|toggle]"
            return 1
            ;;
    esac
}

# List all available plugins
list_plugins() {
    echo "=== Currently Enabled Plugins ==="
    for plugin in "${plugins[@]}"; do
        echo "  ✅ $plugin"
    done
    
    echo "\n=== Available Oh My Zsh Plugins ==="
    if [[ -d "$ZSH/plugins" ]]; then
        for plugin_dir in "$ZSH/plugins"/*; do
            local plugin_name=$(basename "$plugin_dir")
            if (( ! ${plugins[(Ie)$plugin_name]} )); then
                echo "  ⭕ $plugin_name"
            fi
        done
    fi
    
    echo "\n=== Custom Plugins ==="
    if [[ -d "$ZSH_CUSTOM_PLUGINS" ]]; then
        for plugin_dir in "$ZSH_CUSTOM_PLUGINS"/*; do
            [[ -d "$plugin_dir" ]] && echo "  🔧 $(basename "$plugin_dir")"
        done
    fi
}

# =============================================================================
# Performance Monitoring
# =============================================================================

# Plugin loading time analysis
if [[ "$ZSH_PLUGIN_DEBUG" == "true" ]]; then
    # Time plugin loading
    for plugin in "${plugins[@]}"; do
        local start_time=$(date +%s.%N)
        # Plugin will be loaded by Oh My Zsh
        local end_time=$(date +%s.%N)
        local duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "0")
        echo "Plugin '$plugin' loaded in ${duration}s"
    done
fi

# =============================================================================
# Custom Plugin Utilities
# =============================================================================

# Update all custom plugins
update_custom_plugins() {
    echo "🔄 Updating custom plugins..."
    
    if [[ -d "$ZSH_CUSTOM_PLUGINS" ]]; then
        for plugin_dir in "$ZSH_CUSTOM_PLUGINS"/*; do
            if [[ -d "$plugin_dir/.git" ]]; then
                local plugin_name=$(basename "$plugin_dir")
                echo "Updating $plugin_name..."
                (cd "$plugin_dir" && git pull --quiet) && \
                    echo "✅ $plugin_name updated" || \
                    echo "❌ Failed to update $plugin_name"
            fi
        done
    fi
    
    echo "✅ Custom plugin updates completed"
}

# Remove unused custom plugins
cleanup_plugins() {
    echo "🧹 Cleaning up unused custom plugins..."
    
    if [[ -d "$ZSH_CUSTOM_PLUGINS" ]]; then
        for plugin_dir in "$ZSH_CUSTOM_PLUGINS"/*; do
            local plugin_name=$(basename "$plugin_dir")
            if (( ! ${plugins[(Ie)$plugin_name]} )); then
                echo "Found unused plugin: $plugin_name"
                read "REPLY?Remove $plugin_name? [y/N] "
                if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                    rm -rf "$plugin_dir"
                    echo "❌ Removed $plugin_name"
                fi
            fi
        done
    fi
}

# =============================================================================
# Plugin Recommendations
# =============================================================================

# Suggest plugins based on installed tools
suggest_plugins() {
    echo "=== Plugin Recommendations ==="
    
    # Check for tools and suggest relevant plugins
    local suggestions=()
    
    command -v docker >/dev/null 2>&1 && \
        (( ! ${plugins[(Ie)docker]} )) && suggestions+=("docker")
    
    command -v kubectl >/dev/null 2>&1 && \
        (( ! ${plugins[(Ie)kubectl]} )) && suggestions+=("kubectl")
    
    command -v aws >/dev/null 2>&1 && \
        (( ! ${plugins[(Ie)aws]} )) && suggestions+=("aws")
    
    command -v terraform >/dev/null 2>&1 && \
        (( ! ${plugins[(Ie)terraform]} )) && suggestions+=("terraform")
    
    [[ -d ".git" ]] && \
        (( ! ${plugins[(Ie)git-flow]} )) && suggestions+=("git-flow")
    
    if [[ ${#suggestions[@]} -gt 0 ]]; then
        echo "Based on your installed tools, consider enabling:"
        for suggestion in "${suggestions[@]}"; do
            echo "  💡 $suggestion"
        done
        echo "\nEnable with: toggle_plugin <plugin-name> enable"
    else
        echo "No additional plugin recommendations at this time."
    fi
}

# =============================================================================
# Export Plugin Configuration
# =============================================================================

# Make plugin management functions available globally
autoload -U toggle_plugin list_plugins update_custom_plugins cleanup_plugins suggest_plugins

# =============================================================================
# Completion Configuration
# =============================================================================

# Enhanced completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' special-dirs true

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Faster completion for git
__git_files () { 
    _wanted files expl 'local files' _files     
}
#!/usr/bin/env zsh

add_to_path() {
    local dir="$1"
    local position="${2:-end}"
    
    if [[ ! -d "$dir" ]]; then
        return 1
    fi
    
    case ":$PATH:" in
        *":$dir:"*) return 0 ;;
    esac
    
    if [[ "$position" == "start" ]]; then
        export PATH="$dir:$PATH"
    else
        export PATH="$PATH:$dir"
    fi
}

remove_from_path() {
    local dir="$1"
    PATH=$(echo "$PATH" | sed -e "s|:$dir||g" -e "s|$dir:||g" -e "s|$dir||g")
    export PATH
}

clean_path() {
    local new_path=""
    local dir
    
    for dir in $(echo "$PATH" | tr ':' '\n'); do
        if [[ -n "$dir" && -d "$dir" ]]; then
            case ":$new_path:" in
                *":$dir:"*) ;;
                *) new_path="$new_path:$dir" ;;
            esac
        fi
    done
    
    export PATH="${new_path#:}"
}

add_to_path "$HOME/.local/bin" start
add_to_path "$HOME/bin" start

if [[ "$OSTYPE" == darwin* ]]; then
    if [[ -d "/opt/homebrew" ]]; then
        add_to_path "/opt/homebrew/bin" start
        add_to_path "/opt/homebrew/sbin" start
    fi
    
    if [[ -d "/usr/local/homebrew" ]]; then
        add_to_path "/usr/local/homebrew/bin" start
        add_to_path "/usr/local/homebrew/sbin" start
    fi
fi

add_to_path "/opt/homebrew/opt/node@20/bin"
add_to_path "/opt/homebrew/opt/node@18/bin"

if command -v python3 >/dev/null 2>&1; then
    PYTHON_USER_BASE=$(python3 -m site --user-base 2>/dev/null)
    if [[ -n "$PYTHON_USER_BASE" ]]; then
        add_to_path "$PYTHON_USER_BASE/bin"
    fi
fi

add_to_path "/opt/homebrew/opt/ruby/bin"
if [[ -d "/opt/homebrew/lib/ruby/gems" ]]; then
    for ruby_version in /opt/homebrew/lib/ruby/gems/*/bin; do
        [[ -d "$ruby_version" ]] && add_to_path "$ruby_version"
    done
fi

if [[ -n "$GOPATH" ]]; then
    add_to_path "$GOPATH/bin"
fi

add_to_path "$HOME/.cargo/bin"

add_to_path "/opt/homebrew/opt/openjdk@17/bin"
add_to_path "/opt/homebrew/opt/openjdk@11/bin"
add_to_path "/opt/homebrew/opt/openjdk@8/bin"

if [[ -n "$ANDROID_HOME" ]]; then
    add_to_path "$ANDROID_HOME/emulator"
    add_to_path "$ANDROID_HOME/tools"
    add_to_path "$ANDROID_HOME/tools/bin"
    add_to_path "$ANDROID_HOME/platform-tools"
fi

add_to_path "$HOME/flutter/bin"
add_to_path "/opt/homebrew/opt/flutter/bin"

add_to_path "/Applications/Docker.app/Contents/Resources/bin"

add_to_path "/Applications/WebStorm.app/Contents/MacOS"
add_to_path "/Applications/IntelliJ IDEA.app/Contents/MacOS"
add_to_path "/Applications/PyCharm.app/Contents/MacOS"
add_to_path "/Applications/PhpStorm.app/Contents/MacOS"

if [[ "$OSTYPE" == darwin* ]]; then
    add_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

if [[ "$OSTYPE" == darwin* ]]; then
    add_to_path "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
fi

if [[ -n "$PNPM_HOME" ]]; then
    case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi

add_to_path "$HOME/.yarn/bin"
add_to_path "$HOME/.config/yarn/global/node_modules/.bin"

if command -v npm >/dev/null 2>&1; then
    NPM_GLOBAL_PREFIX=$(npm config get prefix 2>/dev/null)
    if [[ -n "$NPM_GLOBAL_PREFIX" && "$NPM_GLOBAL_PREFIX" != "undefined" ]]; then
        add_to_path "$NPM_GLOBAL_PREFIX/bin"
    fi
fi

setup_nvm_lazy() {
    export NVM_DIR="$HOME/.nvm"
    
    load_nvm() {
        unset -f nvm node npm npx
        if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
            source "/opt/homebrew/opt/nvm/nvm.sh"
        elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
            source "$NVM_DIR/nvm.sh"
        fi
        
        if [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]]; then
            source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
        elif [[ -s "$NVM_DIR/bash_completion" ]]; then
            source "$NVM_DIR/bash_completion"
        fi
    }
    
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

setup_nvm_lazy

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

if [[ "$OSTYPE" == darwin* ]]; then
    add_to_path "/usr/local/texlive/2023/bin/universal-darwin"
    add_to_path "/usr/local/texlive/2022/bin/universal-darwin"
    
    add_to_path "/opt/homebrew/opt/postgresql@14/bin"
    add_to_path "/opt/homebrew/opt/postgresql@13/bin"
    
    add_to_path "/opt/homebrew/opt/mysql@8.0/bin"
    add_to_path "/opt/homebrew/opt/mysql@5.7/bin"
fi

clean_path

unset -f add_to_path remove_from_path clean_path setup_nvm_lazy
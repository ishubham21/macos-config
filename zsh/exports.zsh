#!/usr/bin/env zsh

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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

export VISUAL="$EDITOR"
export PAGER='less'
export MANPAGER='less'
export LESS='-R -i -w -M -z-4'

export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="$HOME/.zsh_history"

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

export NODE_OPTIONS="--max-old-space-size=8192"
export NPM_CONFIG_PROGRESS=false
export NODE_ENV="production"

export PYTHONDONTWRITEBYTECODE=1
export PIP_REQUIRE_VIRTUALENV=false

if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/go"
    export GOOS="$(go env GOOS 2>/dev/null || echo 'unknown')"
    export GOARCH="$(go env GOARCH 2>/dev/null || echo 'unknown')"
fi

if [[ -d "$HOME/.cargo" ]]; then
    export CARGO_HOME="$HOME/.cargo"
fi

if [[ -d "/opt/homebrew/opt/openjdk@17" ]]; then
    export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
elif [[ -d "/usr/libexec/java_home" ]] && /usr/libexec/java_home >/dev/null 2>&1; then
    export JAVA_HOME="$(/usr/libexec/java_home)"
fi

if [[ -d "$HOME/Library/Android/sdk" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
fi

export GPG_TTY=$(tty)
export SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

if [[ -d "/opt/homebrew" ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
    export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

if [[ -d "$HOME/Library/pnpm" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
fi

setopt NO_GLOB_DOTS

autoload -Uz compinit

if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
    compinit -d ~/.zcompdump
else
    compinit -C -d ~/.zcompdump
fi

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

if command -v kubectl >/dev/null 2>&1; then
    export KUBE_EDITOR="$EDITOR"
fi

if command -v terraform >/dev/null 2>&1; then
    export TF_CLI_ARGS_plan="-parallelism=10"
    export TF_CLI_ARGS_apply="-parallelism=10"
fi

export AWS_PAGER=""

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export LESSHISTFILE="/dev/null"
export MYSQL_HISTFILE="/dev/null"

export BROWSER="open"
export TERM="xterm-256color"

export PYTHONPATH="$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH"
export PIP_USER=1

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

export YSU_MESSAGE_POSITION="after"
export YSU_HARDCORE=1

export DISABLE_UNTRACKED_FILES_DIRTY="true"
export COMPLETION_WAITING_DOTS="true"
#!/usr/bin/env zsh

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/zsh/exports.zsh"
source "$DOTFILES/zsh/path.zsh"
source "$DOTFILES/zsh/plugins.zsh"

source "$ZSH/oh-my-zsh.sh"

source "$DOTFILES/zsh/aliases.zsh"
source "$DOTFILES/zsh/functions.zsh"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
#!/usr/bin/env zsh

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"

source "$ZSH/oh-my-zsh.sh"

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/zsh/exports.zsh"
source "$DOTFILES/zsh/path.zsh"
source "$DOTFILES/zsh/aliases.zsh"
source "$DOTFILES/zsh/functions.zsh"
source "$DOTFILES/zsh/plugins.zsh"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
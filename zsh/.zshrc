# .zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
if [ -s "$ZSH/oh-my-zsh.sh" ]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# Basic settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
unsetopt SHARE_HISTORY
setopt APPEND_HISTORY

# Key bindings
bindkey -e

# LS colors
export CLICOLOR=1
if [[ "$OSTYPE" == "darwin"* ]]; then
    export LSCOLORS="Gxfxcxdxbxegedabagacad"
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias grep='grep --color=auto'

# Aliases
alias ll='ls -lh'
alias c='clear -x'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias view='nvim -R'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias desk='ssh jhu@68.237.90.220'

# Ripgrep configuration
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# Use delta as pager for fd (when outputting to a TTY)
if command -v fd &> /dev/null; then
    alias fd-delta='fd --color=always | delta'
fi

# NVM
export NVM_DIR="$HOME/.nvm"
# Standard / Linux
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
# MacOS (Homebrew - fallback if already installed that way)
elif [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    . "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
elif [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
    . "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
fi

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PATH=$HOME/bin:$HOME/.local/bin:$PATH

# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Source local config if it exists
if [ -f ~/.zshrc_local ]; then
    . ~/.zshrc_local
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# .zshrc

# Basic settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Key bindings
bindkey -e

# LS colors
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
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# Ripgrep configuration
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# Use delta as pager for fd (when outputting to a TTY)
if command -v fd &> /dev/null; then
    alias fd-delta='fd --color=always | delta'
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PATH=$HOME/bin:$HOME/.local/bin:$PATH

# Initialize Starship
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Source local config if it exists
if [ -f ~/.zshrc_local ]; then
    . ~/.zshrc_local
fi

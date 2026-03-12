# .bashrc
export BASH_SILENCE_DEPRECATION_WARNING=1

# Basic settings
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# Colored prompt (PS1)
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# LS colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Aliases
alias ll='ls -l'
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

# Modern CLI tools
if command -v fdfind &> /dev/null; then
    alias fd='fdfind'
fi

# Ripgrep configuration
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# Use delta as pager for fd (when outputting to a TTY)
if command -v fd &> /dev/null || command -v fdfind &> /dev/null; then
    alias fd-delta='fd --color=always | delta'
fi

# Initialize Starship
eval "$(starship init bash)"

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PATH=$HOME/bin:$HOME/.local/bin:$PATH

# Source local config if it exists
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

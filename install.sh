#!/bin/bash

# install.sh - Robust dotfiles installation script

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

# Function to symlink a file, backing up the existing one
link_file() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up $dest to $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    elif [ -L "$dest" ]; then
        echo "Removing existing symlink $dest"
        rm "$dest"
    fi

    echo "Creating symlink: $dest -> $src"
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
}

echo "Starting dotfiles installation..."

# Bash
link_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

# Neovim
link_file "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# Tmux
link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

echo "Installation complete!"
echo "Please restart your shell or source ~/.bashrc to see changes."

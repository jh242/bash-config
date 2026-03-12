#!/bin/bash

# install.sh - Robust dotfiles installation script

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

# --- OS Detection ---
OS="$(uname -s)"
case "$OS" in
    Linux*)     DISTRO=$(lsb_release -si 2>/dev/null || cat /etc/os-release | grep ^ID= | cut -d'=' -f2 | tr -d '"') ;;
    Darwin*)    DISTRO="MacOS" ;;
    *)          DISTRO="Unknown" ;;
esac

echo "Detected OS: $OS ($DISTRO)"

# --- Dependency Installation ---
install_dependencies() {
    echo "Checking and installing dependencies..."
    
    if [ "$DISTRO" == "MacOS" ]; then
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install git neovim tmux starship nvm git-delta ripgrep fd
        # Dev Tools & Formatters
        brew install node python3 cmake clang-format black prettier
    elif [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ]; then
        sudo apt-get update
        sudo apt-get install -y git tmux curl git-delta ripgrep fd-find
        # Dev Tools & Formatters
        sudo apt-get install -y python3 python3-pip python3-venv build-essential cmake g++ clangd clang-format
        
        # Install latest Neovim AppImage for Linux (extracted for FUSE compatibility)
        echo "Installing Neovim AppImage..."
        mkdir -p "$HOME/.local/bin"
        mkdir -p "$HOME/.local/lib"
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
        chmod +x nvim-linux-x86_64.appimage
        
        # Extract the AppImage to avoid FUSE dependency issues (common in WSL/Containers)
        ./nvim-linux-x86_64.appimage --appimage-extract > /dev/null
        rm -rf "$HOME/.local/lib/nvim-appimage"
        mv squashfs-root "$HOME/.local/lib/nvim-appimage"
        ln -sf "$HOME/.local/lib/nvim-appimage/AppRun" "$HOME/.local/bin/nvim"
        rm nvim-linux-x86_64.appimage

        # Install Starship
        if ! command -v starship &> /dev/null; then
            curl -sS https://starship.rs/install.sh | sh -s -- -y
        fi
        
        # Install NVM
        if [ ! -d "$HOME/.nvm" ]; then
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            nvm install --lts
        fi
    else
        echo "Unsupported OS/Distro for automatic dependency installation. Please install git, neovim, tmux, starship, and nvm manually."
    fi
}

# --- Link Files ---
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

# --- Main ---
read -p "Install dependencies? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_dependencies
fi

echo "Installing dotfiles configurations..."

# Bash
link_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

# Neovim
link_file "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# Tmux
link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Git
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Ripgrep
link_file "$DOTFILES_DIR/rg/.ripgreprc" "$HOME/.ripgreprc"

echo "Installation complete!"
echo "Please restart your shell or run: source ~/.bashrc"
echo "Note: If NVM was installed, you may need to restart your terminal."

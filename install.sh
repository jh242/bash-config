#!/bin/bash

# install.sh - dotfiles installer for macOS and Arch Linux using zsh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

# --- OS Detection ---
OS="$(uname -s)"
DISTRO="Unknown"

if [ "$OS" = "Darwin" ]; then
	DISTRO="macOS"
elif [ "$OS" = "Linux" ] && [ -r /etc/os-release ]; then
	. /etc/os-release
	DISTRO="${ID:-Unknown}"
fi

case "$DISTRO" in
macOS | arch) ;;
*)
	echo "Unsupported OS: $OS ($DISTRO)"
	echo "This installer supports macOS and Arch Linux with zsh."
	exit 1
	;;
esac

echo "Detected OS: $OS ($DISTRO)"

install_nvm_node() {
	# Install NVM via the standard path
	if [ ! -d "$HOME/.nvm" ]; then
		echo "Installing NVM via official script..."
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	fi

	# Setup NVM and Install Node LTS
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

	if command -v nvm &>/dev/null; then
		echo "Installing and using Node.js LTS via NVM..."
		nvm install --lts
		nvm use --lts
		nvm alias default 'lts/*'

		echo "Installing global npm packages..."
		npm install -g prettier
	fi
}

# --- Dependency Installation ---
install_dependencies() {
	echo "Checking and installing dependencies..."

	if [ "$DISTRO" = "macOS" ]; then
		if ! command -v brew &>/dev/null; then
			echo "Homebrew not found. Installing Homebrew..."
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi

		brew install git neovim tmux git-delta ripgrep fd zsh python3 cmake clang-format black
	elif [ "$DISTRO" = "arch" ]; then
		sudo pacman -Syu --needed \
			git neovim tmux git-delta ripgrep fd zsh \
			curl wget unzip tar gzip ca-certificates \
			python python-pip base-devel cmake clang python-black
	fi

	install_nvm_node
}

# --- Oh My Zsh + Powerlevel10k ---
install_omz_p10k() {
	echo "Installing Oh My Zsh and Powerlevel10k..."

	# Oh My Zsh - unattended, do not chsh, do not run zsh, keep existing .zshrc
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
			sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	else
		echo "Oh My Zsh already installed."
	fi

	# Powerlevel10k theme into the custom themes directory
	local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
	local p10k_dir="$zsh_custom/themes/powerlevel10k"
	if [ ! -d "$p10k_dir" ]; then
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
	else
		echo "Powerlevel10k already installed; pulling latest..."
		git -C "$p10k_dir" pull --ff-only
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

read -p "Install Oh My Zsh and Powerlevel10k? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	install_omz_p10k
fi

echo "Installing dotfiles configurations..."

# Zsh
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Neovim
link_file "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# Tmux
link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Tmux plugin manager (tpm) — needed for tmux-cpu and other plugins
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
	echo "Installing tpm..."
	git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
	echo "tpm already installed; pulling latest..."
	git -C "$TPM_DIR" pull --ff-only
fi
# Install declared plugins headlessly
"$TPM_DIR/bin/install_plugins" >/dev/null 2>&1 || true

# Git
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Ripgrep
link_file "$DOTFILES_DIR/rg/.ripgreprc" "$HOME/.ripgreprc"

echo "Installation complete!"
echo "Please restart your terminal or run: source ~/.zshrc"
echo "Note: If NVM was installed, you may need to restart your terminal."

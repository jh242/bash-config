# Dotfiles Repository

A sensible configuration for Bash, Neovim, and Tmux.

## Features

- **Bash**: Sensible aliases, colored prompt, and local config support.
- **Neovim**: Plugin-ready configuration with `lazy.nvim`, Telescope, Treesitter, and Gruvbox.
- **Tmux**: Ergonomic prefix (`C-a`), mouse support, and pane navigation shortcuts.

## Prerequisites

Ensure you have the following installed:
- `git`
- `nvim` (0.8.0 or later)
- `tmux`
- `bash`

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

3. Open Neovim to trigger plugin installation:
   ```bash
   nvim
   ```

## Customization

You can add a `~/.bashrc_local` file for machine-specific configurations that won't be tracked in this repository.

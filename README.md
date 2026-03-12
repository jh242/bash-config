# Dotfiles Repository

A sensible configuration for Bash, Neovim, and Tmux.

## Features

- **Bash**: Sensible aliases, colored prompt, and local config support.
- **Neovim**: Plugin-ready configuration with `lazy.nvim`, Telescope, Treesitter, and Gruvbox.
- **Tmux**: Ergonomic prefix (`C-a`), mouse support, and custom shortcuts.
- **Tools**: Automated installation of `starship`, `nvm`, `git-delta` (rich git diffs), `ripgrep` (`rg`), and `fd`.
- **Fonts**: Automated installation of **Geist Mono Nerd Font** (required for the icons in Starship, Lualine, etc.).

## Prerequisites

Ensure you have the following installed (or let `install.sh` do it for you):
- `git`
- `nvim` (0.11+ recommended, provided as AppImage on Linux)
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

## Keybindings

### Neovim (Leader: Space)

| Binding | Action |
| :--- | :--- |
| `<leader>ff` | Search for files (Telescope) |
| `<leader>fg` | Search for text in files (Live Grep) |
| `<leader>e` | Open File Explorer (Netrw) |
| `<leader>gb` | Toggle Git Blame (ghost text) |
| `<leader>f` | Format current buffer (Neoformat) |

### Tmux (Prefix: Ctrl-a)

| Binding | Action |
| :--- | :--- |
| `Prefix` + `=` | Split pane vertically (side by side) |
| `Prefix` + `-` | Split pane horizontally (up and down) |
| `Prefix` + `h` | Move to left pane |
| `Prefix` + `j` | Move to bottom pane |
| `Prefix` + `k` | Move to top pane |
| `Prefix` + `l` | Move to right pane |
| `Prefix` + `Arrow` | Resize current pane (repeatable) |
| `Prefix` + `r` | Reload tmux config |

## Customization

You can add a `~/.bashrc_local` file for machine-specific configurations that won't be tracked in this repository.

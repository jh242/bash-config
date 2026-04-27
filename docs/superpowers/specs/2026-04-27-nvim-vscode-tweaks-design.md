# nvim VSCode-like Tweaks — Design

Date: 2026-04-27

## Goal

Bring nvim closer to VSCode in **visual chrome and feature parity** while keeping
all vim motions, modal editing, and existing leader-prefixed bindings intact.
No VSCode keybindings layered on top, no terminal panel, no symbol outline,
no breadcrumbs, no notification system.

## Scope

Modify `nvim/init.lua` only. No new files. Plugins managed via lazy.nvim
following the existing pattern.

## Plugin Additions

| Plugin | Purpose |
|---|---|
| `nvim-tree/nvim-tree.lua` | File tree sidebar |
| `akinsho/bufferline.nvim` | Buffer tabs along the top |
| `folke/trouble.nvim` | Diagnostics panel |
| `numToStr/Comment.nvim` | `gcc` / `gc` comment toggle |
| `windwp/nvim-autopairs` | Auto-close brackets / quotes, cmp-integrated |
| `lukas-reineke/indent-blankline.nvim` | Indent guides |
| `folke/which-key.nvim` | Leader-key discovery popup |
| `stevearc/conform.nvim` | Format-on-save (replaces `neoformat`) |
| `nvim-pack/nvim-spectre` | Project-wide find/replace UI |
| `hrsh7th/cmp-buffer` | cmp source: current buffer words |
| `hrsh7th/cmp-path` | cmp source: filesystem paths |
| `saadparwaiz1/cmp_luasnip` | cmp source: LuaSnip snippets |
| `rafamadriz/friendly-snippets` | Standard snippet library |

## Plugin Removals

- `sbdchd/neoformat` — replaced by `conform.nvim`.

## Configuration Changes

### Diagnostics (built-in, no lspsaga)

```lua
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = 'rounded', source = true },
  signs = true,
})
```

### nvim-cmp wiring

Extend the existing cmp setup so LuaSnip + friendly-snippets + buffer + path
sources are registered. Configure mappings: `<CR>` confirm, `<Tab>` /
`<S-Tab>` navigate menu and snippet jumps.

### conform.nvim

```lua
formatters_by_ft = {
  python = { "black" },
  javascript = { "prettier" },
  typescript = { "prettier" },
  typescriptreact = { "prettier" },
  javascriptreact = { "prettier" },
  css = { "prettier" },
  html = { "prettier" },
  c = { "clang_format" },
  cpp = { "clang_format" },
  lua = { "stylua" },
}
format_on_save = { lsp_fallback = true, timeout_ms = 500 }
```

`stylua` added to `mason-tool-installer` ensure_installed list.

### nvim-autopairs

Default config + `cmp.event:on('confirm_done', ...)` hook so completing a
function inserts `()` correctly.

### bufferline

Default config; let everforest theme drive colors.

### nvim-tree

Disable netrw at top of init.lua (`vim.g.loaded_netrw = 1`,
`vim.g.loaded_netrwPlugin = 1`). Default config otherwise.

### which-key

Default config. Register descriptions for the leader groups (`<leader>g`,
`<leader>n`, `<leader>h`, `<leader>f`).

## Keymap Changes

Replace / add:

| Mapping | Action | Notes |
|---|---|---|
| `<leader>e` | Toggle nvim-tree | Replaces existing `:Ex` mapping |
| `<S-l>` | Next buffer | bufferline cycle |
| `<S-h>` | Previous buffer | bufferline cycle |
| `<leader>x` | Close current buffer | `:bdelete` |
| `<leader>p` | `Telescope commands` | Command palette |
| `<leader>?` | `Telescope keymaps` | Keybinding browser |
| `<leader>d` | `vim.diagnostic.open_float` | Line diagnostic |
| `<leader>nn` | `Trouble diagnostics toggle` | Workspace |
| `<leader>nb` | `Trouble diagnostics toggle filter.buf=0` | Buffer-only |
| `<leader>sr` | Spectre open | Project find/replace |
| `<leader>hp` | `Gitsigns preview_hunk` | |
| `<leader>hs` | `Gitsigns stage_hunk` | |
| `<leader>hr` | `Gitsigns reset_hunk` | |
| `<leader>f` | Replaced — see below | Was `:Neoformat` |

`<leader>f` removed (was manual format via neoformat). Format happens on save
via conform; `<leader>f` is freed for future use or — if desired —
`:lua require("conform").format()` for an ad-hoc trigger. Default: leave
unmapped.

`gcc` / `gc{motion}` from Comment.nvim are not new leader bindings; they're
the plugin's vim-native operator mappings.

## Files Changed

- `nvim/init.lua` — all of the above.

No new files. No changes to other configs.

## Out of Scope

- Terminal panel (toggleterm)
- Symbol outline (aerial)
- Breadcrumbs (dropbar)
- LSP UI overlay (lspsaga)
- Notifications (nvim-notify, noice)
- VSCode-style keybindings (`Ctrl+P`, `Ctrl+/`, `F12`, etc.)

## Verification

Manual after install:

1. `:Lazy sync` completes without errors.
2. `<leader>e` toggles file tree.
3. `<S-l>` / `<S-h>` cycle buffers; bufferline visible.
4. `<leader>p` opens command palette.
5. Open a file with a diagnostic, hit `<leader>d` — float appears with
   rounded border. `<leader>nn` opens trouble panel.
6. `gcc` toggles a line comment.
7. Type `(` — autopair closes it.
8. Save a `.py` / `.ts` / `.lua` file with formatting issues — conform
   applies the formatter.
9. Completion menu shows snippet, buffer, and path entries when relevant.
10. `<leader>sr` opens Spectre.
11. `<leader>hp` previews a git hunk on a modified line.
12. Pause on `<leader>` — which-key popup lists groups.

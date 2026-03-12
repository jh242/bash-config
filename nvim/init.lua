-- init.lua

-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic options
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.termguicolors = true
opt.cursorline = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- UI
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = function() vim.cmd([[colorscheme gruvbox]]) end},
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} },

  -- Fuzzy Finder
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "query", "python", "typescript", "cpp", "bash" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end
  },

  -- LSP and Autocompletion
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "pyright", "clangd", "vtsls" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "prettier", "black" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Neovim 0.11+ Native LSP Configuration
      local servers = { 'pyright', 'clangd', 'vtsls' }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
        vim.lsp.enable(server)
      end
    end
  },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" } },

  -- Git integration
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "f-person/git-blame.nvim", opts = { enabled = true } },

  -- Formatter
  { "sbdchd/neoformat" },

  -- System Clipboard (WSL/Local/SSH)
  {
    "ojroques/nvim-osc52",
    config = function()
      require('osc52').setup({
        silent = true,
      })
      local function copy()
        if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
          require('osc52').copy_register('+')
        end
      end
      vim.api.nvim_create_autocmd('TextYankPost', { callback = copy })
    end
  },
})

-- Keymaps
local keymap = vim.keymap
keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
keymap.set('n', '<leader>e', '<cmd>Ex<cr>', { desc = 'Explorer' })
keymap.set('n', '<leader>gb', '<cmd>GitBlameToggle<cr>', { desc = 'Toggle Git Blame' })
keymap.set('n', '<leader>f', '<cmd>Neoformat<cr>', { desc = 'Format code' })

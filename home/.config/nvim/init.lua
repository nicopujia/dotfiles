-- Bootstrap lazy.nvim (plugin manager) --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Vim settings --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4    
vim.opt.expandtab = true  
vim.opt.softtabstop = 4
vim.opt.clipboard = "unnamedplus" -- Share clipbaord with the OS
vim.opt.termguicolors = true
vim.diagnostic.config({
  virtual_text = true,      -- Show errors as virtual text
  signs = true,             -- Show signs in the gutter
  underline = true,         -- Underline errors
  update_in_insert = false,
  severity_sort = true,
})

local use_light_theme = vim.env.NVIM_THEME == "light"

-- Setup lazy.nvim (plugin manager) --
require("lazy").setup({
  spec = {
    -- plugins! --
    {
      "nvim-telescope/telescope.nvim",
      version = "*",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
      config = function()
        local telescope = require("telescope")
        telescope.setup({
          defaults = {
            file_ignore_patterns = { "node_modules", ".git/" },
          },
        })
        telescope.load_extension("fzf")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep,  { desc = "Search globally" })
        vim.keymap.set("n", "<leader>sb", builtin.buffers,    { desc = "Search buffers" })
      end,
    },
    
    -- light theme
    {
      "EdenEast/nightfox.nvim",
      priority = 1000,
      lazy = not use_light_theme,
      config = function()
        if use_light_theme then
          vim.cmd("colorscheme dayfox")
        end
      end,
    },

    -- theme (monokai with absolute black background)
    {
      "tanvirtin/monokai.nvim",
      priority = 1000,
      lazy = use_light_theme,
      config = function()
        require("monokai") 
        vim.cmd("colorscheme monokai")
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
      end,
    },

    -- Mason setup (LSP manager)
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "mason.nvim",
        "mason-lspconfig.nvim",
      },
      config = function()
        -- Configure ty type checker
        vim.lsp.config('ty', {
          settings = {
            ty = {
              -- ty language server settings can go here
            }
          }
        })
      end,
    },

    {
      "mason-org/mason.nvim",
      name = "mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },

    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = { "mason.nvim" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "ruff" },
        })
        
        -- LSP keybindings
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local opts = { buffer = args.buf }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          end,
        })
        
        -- Auto-format on save for Python files (Ruff only, not ty)
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = '*.py',
          callback = function()
            vim.lsp.buf.format({ 
              async = false,
              filter = function(client) return client.name == "ruff" end
            })
          end,
        })
        
        -- Enable ty (type checker) and Ruff (linter/formatter)
        vim.lsp.enable({"ty", "ruff"})
      end,
    },

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = {

  },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false },
})

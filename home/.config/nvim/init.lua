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
  virtual_text = { spacing = 2, source = "if_many" },
  signs = true,             -- Show signs in the gutter
  underline = true,         -- Underline errors
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_user_command("NvimCheatsheet", function()
  local cheatsheet_path = vim.fn.stdpath("config") .. "/CHEATSHEET.md"
  vim.cmd("edit " .. vim.fn.fnameescape(cheatsheet_path))
  vim.bo.filetype = "markdown"
end, { desc = "Open Neovim cheatsheet" })
vim.keymap.set("n", "<leader>hc", "<cmd>NvimCheatsheet<CR>", { desc = "Open cheatsheet" })

local function should_use_light_theme()
  if vim.env.NVIM_THEME == "light" then
    return true
  end

  if vim.env.NVIM_THEME == "dark" then
    return false
  end

  local system_theme = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  return vim.v.shell_error ~= 0 or not system_theme:match("Dark")
end

local use_light_theme = should_use_light_theme()

local function apply_light_theme_overrides()
  vim.api.nvim_set_hl(0, "Normal", { bg = "#ffffff" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "#ffffff" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#ffffff" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "#ffffff" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "#ffffff" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#ffffff" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#ffffff" })
end

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
        local builtin = require("telescope.builtin")
        local themes = require("telescope.themes")

        telescope.setup({
          defaults = {
            file_ignore_patterns = { "node_modules", ".git/" },
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
              "--hidden",
              "--glob=!**/.git/*",
              "--glob=!**/node_modules/*",
            },
          },
        })
        telescope.load_extension("fzf")

        vim.keymap.set("n", "<leader>sf", function()
          builtin.find_files({ hidden = true, no_ignore = false })
        end, { desc = "Search files" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search globally" })
        vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
        vim.keymap.set("n", "<leader>sr", function()
          builtin.oldfiles(themes.get_dropdown())
        end, { desc = "Search recent files" })
        vim.keymap.set("n", "<leader>sc", function()
          builtin.commands(themes.get_dropdown())
        end, { desc = "Search commands" })
        vim.keymap.set("n", "<leader>sk", function()
          builtin.keymaps(themes.get_dropdown())
        end, { desc = "Search keymaps" })
        vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Search document symbols" })
        vim.keymap.set("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols, { desc = "Search workspace symbols" })
        vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
      end,
    },

    {
      "obsidian-nvim/obsidian.nvim",
      version = "*",
      cmd = "Obsidian",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian new" },
        { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Obsidian open" },
        { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian search" },
        { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian quick switch" },
        { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian today" },
        { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Obsidian workspace" },
      },
      opts = function()
        local vault = vim.env.OBSIDIAN_VAULT
        local workspaces = {}

        if vault ~= nil and vault ~= "" then
          workspaces = { { name = "default", path = vault } }
        else
          -- Set OBSIDIAN_VAULT in ~/.env to enable Obsidian workspace commands.
        end

        return {
          legacy_commands = false,
          workspaces = workspaces,
        }
      end,
    },

    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps",
        },
      },
      config = function(_, opts)
        require("which-key").setup(opts)
        require("which-key").add({
          { "<leader>s", group = "Search" },
          { "<leader>l", group = "LSP" },
          { "<leader>e", group = "Explorer" },
          { "<leader>o", group = "Obsidian" },
          { "<leader>h", group = "Help" },
          { "<leader>x", group = "Diagnostics" },
          { "<leader>c", group = "Code" },
        })
      end,
    },

    {
      "folke/trouble.nvim",
      cmd = "Trouble",
      opts = {},
      keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble diagnostics toggle" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble diagnostics toggle filter.buf=0" },
        { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble symbols toggle focus=false" },
        { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble lsp toggle focus=false win.position=right" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble qflist toggle" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble loclist toggle" },
      },
    },

    {
      "Saghen/blink.cmp",
      version = "1.*",
      opts = {
        completion = {
          menu = { enabled = true },
          documentation = { auto_show = false },
          ghost_text = { enabled = false },
        },
        sources = {
          default = { "lsp", "path", "buffer" },
        },
      },
    },

    {
      "nvim-neo-tree/neo-tree.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      cmd = "Neotree",
      keys = {
        { "<leader>ee", "<cmd>Neotree toggle left filesystem reveal<cr>", desc = "Neotree toggle left filesystem reveal" },
        { "<leader>ef", "<cmd>Neotree focus filesystem left<cr>", desc = "Neotree focus filesystem left" },
        { "<leader>eg", "<cmd>Neotree git_status left<cr>", desc = "Neotree git_status left" },
      },
      opts = {
        window = {
          position = "left",
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            never_show = { ".git" },
          },
        },
      },
    },

    -- light theme
    {
      "EdenEast/nightfox.nvim",
      priority = 1000,
      lazy = not use_light_theme,
      config = function()
        if use_light_theme then
          vim.cmd("colorscheme dayfox")
          apply_light_theme_overrides()
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
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Configure ty type checker
        vim.lsp.config('ty', {
          capabilities = capabilities,
          settings = {
            ty = {
              -- ty language server settings can go here
            }
          }
        })

        vim.lsp.config('ruff', {
          capabilities = capabilities,
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
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Go to references' }))
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
            vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, vim.tbl_extend('force', opts, { desc = 'Format buffer' }))
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
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

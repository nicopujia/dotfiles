return {
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
                file_ignore_patterns = { "node_modules", ".git/", ".venv/" },
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
                    "--glob=!**/.venv/*",
                },
            },
        })
        telescope.load_extension("fzf")

        vim.keymap.set("n", "<leader>sf", function()
            builtin.find_files({
                find_command = {
                    "rg",
                    "--files",
                    "--hidden",
                    "--no-ignore",
                    "--glob=!**/.git/*",
                    "--glob=!**/node_modules/*",
                    "--glob=!**/.venv/*",
                },
            })
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
}

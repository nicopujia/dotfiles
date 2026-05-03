return {
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
            { "<leader>g", group = "Git" },
            { "<leader>o", group = "Obsidian" },
            { "<leader>h", group = "Help" },
            { "<leader>x", group = "Diagnostics" },
            { "<leader>c", group = "Code" },
        })
    end,
}

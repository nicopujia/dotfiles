return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    cmd = "Obsidian",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>on", "<cmd>Obsidian new<cr>",          desc = "Obsidian new" },
        { "<leader>oo", "<cmd>Obsidian open<cr>",         desc = "Obsidian open" },
        { "<leader>os", "<cmd>Obsidian search<cr>",       desc = "Obsidian search" },
        { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian quick switch" },
        { "<leader>ot", "<cmd>Obsidian today<cr>",        desc = "Obsidian today" },
        { "<leader>ow", "<cmd>Obsidian workspace<cr>",    desc = "Obsidian workspace" },
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
}

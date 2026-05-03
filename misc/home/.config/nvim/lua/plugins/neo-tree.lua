local neotree = require("config.neotree")
local theme = require("config.theme")

return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "<leader>ee", neotree.toggle_visibility, desc = "Neotree toggle visibility" },
        { "<leader>ef", neotree.toggle_files,      desc = "Neotree files" },
        { "<leader>eg", neotree.toggle_git,        desc = "Neotree git" },
    },
    opts = {
        close_if_last_window = true,
        source_selector = {
            winbar = false,
            statusline = true,
            padding = { left = 1, right = 0 },
            highlight_background = "NeoTreeNormal",
            sources = {
                { source = "filesystem", display_name = "Files" },
                { source = "git_status", display_name = "Git" },
            },
        },
        window = {
            position = "left",
            width = 40,
        },
        filesystem = {
            use_libuv_file_watcher = true,
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
            },
        },
        git_status = {
            renderers = {
                directory = {
                    { "indent", indent_size = 2, padding = 0, with_markers = true },
                    { "icon" },
                    { "name", zindex = 10 },
                },
                file = {
                    { "indent", indent_size = 2, padding = 0, with_markers = true },
                    { "icon" },
                    { "name", zindex = 10, use_git_status_colors = true },
                    { "git_status", zindex = 20, align = "right" },
                },
            },
        },
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)
        theme.apply_neotree_source_selector_highlights()
        theme.apply_statusline_highlights()

        vim.api.nvim_create_autocmd("WinClosed", {
            group = vim.api.nvim_create_augroup("KeepNeotreeSidebarWidth", { clear = true }),
            callback = function()
                vim.schedule(neotree.keep_sidebar_width)
            end,
        })
    end,
}

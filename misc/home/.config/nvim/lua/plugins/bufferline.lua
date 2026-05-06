local buffers = require("config.buffers")
local theme = require("config.theme")
local fill_bg = theme.use_light_theme and "#e5e5e5" or "#000000"

return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
        { "gt", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer tab" },
        { "gT", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer tab" },
    },
    opts = {
        highlights = {
            fill = { bg = fill_bg },
            separator = { fg = fill_bg, bg = fill_bg },
            separator_visible = { fg = fill_bg, bg = fill_bg },
            separator_selected = { fg = fill_bg, bg = fill_bg },
            indicator_selected = { fg = "#ff9700", bg = fill_bg },
        },
        options = {
            close_command = buffers.close_buffer,
            right_mouse_command = buffers.close_buffer,
            diagnostics = "nvim_lsp",
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "",
                    text_align = "left",
                    padding = 1,
                    separator = false,
                },
            },
        },
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
        theme.apply_bufferline_highlights()
    end,
}

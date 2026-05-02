local buffers = require("config.buffers")
local theme = require("config.theme")

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
            fill = { bg = "#000000" },
            separator = { fg = "#000000", bg = "#000000" },
            separator_visible = { fg = "#000000", bg = "#000000" },
            separator_selected = { fg = "#000000", bg = "#000000" },
            indicator_selected = { fg = "#ff9700", bg = "#000000" },
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

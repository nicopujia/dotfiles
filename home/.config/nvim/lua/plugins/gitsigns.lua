return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "_" },
            changedelete = { text = "~" },
            untracked = { text = "+" },
        },
        signs_staged_enable = true,
        current_line_blame = false,
    },
}

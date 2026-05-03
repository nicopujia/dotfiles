return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Trouble diagnostics toggle" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Trouble diagnostics toggle filter.buf=0" },
        { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Trouble symbols toggle focus=false" },
        { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble lsp toggle focus=false win.position=right" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                             desc = "Trouble qflist toggle" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                            desc = "Trouble loclist toggle" },
    },
}

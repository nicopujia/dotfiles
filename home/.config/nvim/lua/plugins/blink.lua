return {
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
}

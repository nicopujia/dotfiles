return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            javascript = { "biome", "prettier" },
            javascriptreact = { "biome", "prettier" },
            typescript = { "biome", "prettier" },
            typescriptreact = { "biome", "prettier" },
            json = { "biome", "prettier" },
            jsonc = { "biome", "prettier" },
            css = { "prettier" },
            markdown = { "prettier" },
        },
        format_on_save = {
            timeout_ms = 1000,
            lsp_fallback = false,
        },
    },
}

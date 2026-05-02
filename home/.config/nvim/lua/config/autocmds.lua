local theme = require("config.theme")

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("NeotreeSourceSelectorHighlights", { clear = true }),
    callback = theme.apply_neotree_source_selector_highlights,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("NeotreeWindowLocalOptions", { clear = true }),
    pattern = "neo-tree",
    callback = function()
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

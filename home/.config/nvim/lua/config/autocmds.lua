local theme = require("config.theme")

local function open_startup_directory()
    if vim.fn.argc() ~= 1 then
        return
    end

    local target = vim.fn.argv(0)
    if vim.fn.isdirectory(target) ~= 1 then
        return
    end

    local directory_buffer = vim.api.nvim_get_current_buf()

    vim.g.nvim_started_with_directory = true

    vim.cmd("cd " .. vim.fn.fnameescape(target))
    vim.cmd("enew")
    pcall(vim.api.nvim_buf_delete, directory_buffer, { force = true })
    vim.cmd("Neotree focus filesystem left reveal")
end

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("StartupDirectory", { clear = true }),
    callback = open_startup_directory,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ThemeHighlights", { clear = true }),
    callback = function()
        theme.apply_neotree_source_selector_highlights()
        theme.apply_statusline_highlights()
    end,
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

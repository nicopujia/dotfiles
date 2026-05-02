vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.conceallevel = 2

if vim.fn.executable("zsh") == 1 then
    vim.opt.shell = "zsh"
    vim.opt.shellcmdflag = "-ic"
end

vim.diagnostic.config({
    virtual_text = { spacing = 2, source = "if_many" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

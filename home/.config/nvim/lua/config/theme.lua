local M = {}

function M.should_use_light_theme()
    if vim.env.NVIM_THEME == "light" then
        return true
    end

    if vim.env.NVIM_THEME == "dark" then
        return false
    end

    local system_theme = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
    return vim.v.shell_error ~= 0 or not system_theme:match("Dark")
end

M.use_light_theme = M.should_use_light_theme()

function M.apply_light_theme_overrides()
    vim.api.nvim_set_hl(0, "Normal", { bg = "#ffffff" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#ffffff" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#ffffff" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#ffffff" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "#ffffff" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#ffffff" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#ffffff" })
end

function M.apply_neotree_source_selector_highlights()
    vim.api.nvim_set_hl(0, "NeoTreeTabActive", { bg = "#262626", fg = "#f5f5f5", bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { bg = "#1f1f1f", fg = "#b8b8b8" })
    vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorActive", { bg = "#262626", fg = "#262626" })
    vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorInactive", { bg = "#1f1f1f", fg = "#1f1f1f" })
end

function M.apply_statusline_highlights()
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#444444", fg = "#e6e6e6" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#262626", fg = "#b8b8b8" })
    vim.api.nvim_set_hl(0, "NeoTreeStatusLine", { bg = "#444444", fg = "#e6e6e6" })
    vim.api.nvim_set_hl(0, "NeoTreeStatusLineNC", { bg = "#262626", fg = "#b8b8b8" })
end

function M.apply_bufferline_highlights()
    vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = "#000000", bg = "#000000" })
    vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = "#000000", bg = "#000000" })
    vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = "#000000", bg = "#000000" })
    vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = "#ff9700", bg = "#000000" })
end

return M

local M = {}

local palette = {
    light = {
        editor_bg = "#ffffff",
        sidebar_bg = "#ebebeb",
        chrome_bg = "#e5e5e5",
        chrome_bg_muted = "#d9d9d9",
        chrome_fg = "#2a2a2a",
        chrome_fg_muted = "#666666",
        accent = "#ff9700",
    },
    dark = {
        sidebar_tab_active_bg = "#262626",
        sidebar_tab_inactive_bg = "#1f1f1f",
        sidebar_tab_active_fg = "#f5f5f5",
        sidebar_tab_inactive_fg = "#b8b8b8",
        statusline_bg = "#444444",
        statusline_nc_bg = "#262626",
        statusline_fg = "#e6e6e6",
        statusline_nc_fg = "#b8b8b8",
        bufferline_bg = "#000000",
        bufferline_sep = "#000000",
        accent = "#ff9700",
    },
}

function M.should_use_light_theme()
    if vim.env.NVIM_THEME == "light" then
        return true
    end

    if vim.env.NVIM_THEME == "dark" then
        return false
    end

    if vim.loop.os_uname().sysname ~= "Darwin" or vim.fn.executable("defaults") == 0 then
        return false
    end

    local system_theme = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
    return vim.v.shell_error ~= 0 or not system_theme:match("Dark")
end

M.use_light_theme = M.should_use_light_theme()

function M.apply_light_theme_overrides()
    local colors = palette.light

    vim.api.nvim_set_hl(0, "Normal", { bg = colors.editor_bg })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = colors.editor_bg })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.editor_bg })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = colors.editor_bg })
    vim.api.nvim_set_hl(0, "LineNr", { bg = colors.editor_bg })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = colors.editor_bg })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = colors.editor_bg })
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = colors.sidebar_bg })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = colors.sidebar_bg })
    vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = colors.sidebar_bg })
    vim.api.nvim_set_hl(0, "NeoTreeSignColumn", { bg = colors.sidebar_bg })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = colors.sidebar_bg, fg = colors.chrome_bg_muted })
end

function M.apply_neotree_source_selector_highlights()
    if M.use_light_theme then
        local colors = palette.light
        vim.api.nvim_set_hl(0, "NeoTreeTabActive", { bg = colors.sidebar_bg, fg = colors.chrome_fg, bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { bg = colors.chrome_bg, fg = colors.chrome_fg_muted })
        vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorActive", { bg = colors.sidebar_bg, fg = colors.sidebar_bg })
        vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorInactive", { bg = colors.chrome_bg, fg = colors.chrome_bg })
        return
    end

    local colors = palette.dark
    vim.api.nvim_set_hl(0, "NeoTreeTabActive", { bg = colors.sidebar_tab_active_bg, fg = colors.sidebar_tab_active_fg, bold = true })
    vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { bg = colors.sidebar_tab_inactive_bg, fg = colors.sidebar_tab_inactive_fg })
    vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorActive", { bg = colors.sidebar_tab_active_bg, fg = colors.sidebar_tab_active_bg })
    vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorInactive", { bg = colors.sidebar_tab_inactive_bg, fg = colors.sidebar_tab_inactive_bg })
end

function M.apply_statusline_highlights()
    if M.use_light_theme then
        local colors = palette.light
        vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.chrome_bg, fg = colors.chrome_fg })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.chrome_bg_muted, fg = colors.chrome_fg_muted })
        vim.api.nvim_set_hl(0, "NeoTreeStatusLine", { bg = colors.sidebar_bg, fg = colors.chrome_fg })
        vim.api.nvim_set_hl(0, "NeoTreeStatusLineNC", { bg = colors.sidebar_bg, fg = colors.chrome_fg_muted })
        return
    end

    local colors = palette.dark
    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.statusline_bg, fg = colors.statusline_fg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.statusline_nc_bg, fg = colors.statusline_nc_fg })
    vim.api.nvim_set_hl(0, "NeoTreeStatusLine", { bg = colors.statusline_bg, fg = colors.statusline_fg })
    vim.api.nvim_set_hl(0, "NeoTreeStatusLineNC", { bg = colors.statusline_nc_bg, fg = colors.statusline_nc_fg })
end

function M.apply_bufferline_highlights()
    if M.use_light_theme then
        local colors = palette.light
        vim.api.nvim_set_hl(0, "BufferLineFill", { bg = colors.chrome_bg })
        vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = colors.chrome_bg, bg = colors.chrome_bg })
        vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = colors.chrome_bg, bg = colors.chrome_bg })
        vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = colors.chrome_bg, bg = colors.chrome_bg })
        vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = colors.accent, bg = colors.chrome_bg })
        return
    end

    local colors = palette.dark
    vim.api.nvim_set_hl(0, "BufferLineFill", { bg = colors.bufferline_bg })
    vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = colors.bufferline_sep, bg = colors.bufferline_sep })
    vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = colors.bufferline_sep, bg = colors.bufferline_sep })
    vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = colors.bufferline_sep, bg = colors.bufferline_sep })
    vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = colors.accent, bg = colors.bufferline_bg })
end

return M

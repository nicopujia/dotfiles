local M = {}

local last_source = "filesystem"

function M.focus_editor_window()
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buffer = vim.api.nvim_win_get_buf(window)
        if vim.bo[buffer].filetype ~= "neo-tree" then
            vim.api.nvim_set_current_win(window)
            return
        end
    end
end

local function source_from_buffer(buffer)
    local name = vim.api.nvim_buf_get_name(buffer)
    return name:match("neo%-tree ([%w_]+)")
end

local function find_window()
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buffer = vim.api.nvim_win_get_buf(window)
        if vim.bo[buffer].filetype == "neo-tree" then
            return window, buffer
        end
    end
end

function M.open_source(source)
    last_source = source

    if source == "git_status" then
        vim.cmd("Neotree focus git_status left")
    else
        vim.cmd("Neotree focus filesystem left reveal")
    end
end

function M.toggle_visibility()
    local _, buffer = find_window()

    if buffer ~= nil then
        last_source = source_from_buffer(buffer) or last_source
        vim.cmd("Neotree close")
        return
    end

    M.open_source(last_source or "filesystem")
end

function M.toggle_source(source, command)
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_name = vim.api.nvim_buf_get_name(current_buffer)

    if vim.bo[current_buffer].filetype == "neo-tree" and current_name:match("neo%-tree " .. source) then
        M.focus_editor_window()
        return
    end

    last_source = source
    vim.cmd(command)
end

function M.toggle_files()
    M.toggle_source("filesystem", "Neotree focus filesystem left reveal")
end

function M.toggle_git()
    M.toggle_source("git_status", "Neotree focus git_status left")
end

function M.keep_sidebar_width()
    local windows = vim.api.nvim_tabpage_list_wins(0)
    if #windows ~= 1 then
        return
    end

    local neotree_window = windows[1]
    local buffer = vim.api.nvim_win_get_buf(neotree_window)
    if vim.bo[buffer].filetype ~= "neo-tree" then
        return
    end

    vim.api.nvim_set_current_win(neotree_window)
    vim.cmd("rightbelow vnew")
    vim.api.nvim_win_set_width(neotree_window, 40)
end

return M

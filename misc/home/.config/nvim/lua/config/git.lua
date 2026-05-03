local M = {}

function M.open_git_diff(path)
    local git_root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })
    if vim.v.shell_error ~= 0 or git_root[1] == nil then
        vim.api.nvim_err_writeln("Not inside a git repository")
        return
    end

    local command = { "git", "-C", git_root[1], "diff", "--no-ext-diff", "HEAD", "--" }
    local diff_name = "git diff"

    if path ~= nil and path ~= "" then
        local relative_path = vim.fn.fnamemodify(path, ":.")
        table.insert(command, relative_path)
        diff_name = "git diff -- " .. relative_path
    end

    local lines = vim.fn.systemlist(command)
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_err_writeln(table.concat(lines, "\n"))
        return
    end

    if #lines == 0 then
        lines = { "No changes" }
    end

    if vim.bo.filetype == "neo-tree" then
        local editor_window = nil

        for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local window_buffer = vim.api.nvim_win_get_buf(window)
            if vim.bo[window_buffer].filetype ~= "neo-tree" then
                editor_window = window
                break
            end
        end

        if editor_window ~= nil then
            vim.api.nvim_set_current_win(editor_window)
        else
            vim.cmd("rightbelow vnew")
        end
    end

    vim.cmd("enew")

    local buffer = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(buffer, diff_name)
    vim.bo[buffer].buftype = "nofile"
    vim.bo[buffer].bufhidden = "wipe"
    vim.bo[buffer].swapfile = false
    vim.bo[buffer].filetype = "diff"

    vim.bo[buffer].modifiable = true
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
    vim.bo[buffer].modifiable = false
end

function M.open_current_file_git_diff()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" or vim.bo.buftype ~= "" then
        vim.api.nvim_err_writeln("Current buffer is not a file")
        return
    end

    M.open_git_diff(path)
end

function M.setup()
    vim.api.nvim_create_user_command("GitDiff", function(opts)
        M.open_git_diff(opts.args)
    end, { nargs = "?", complete = "file", desc = "Open git diff in a buffer" })

    vim.keymap.set("n", "<leader>gd", function()
        M.open_git_diff()
    end, { desc = "Open git diff" })
    vim.keymap.set("n", "<leader>gD", M.open_current_file_git_diff, { desc = "Open current file git diff" })
end

return M

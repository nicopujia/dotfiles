local M = {}

function M.close_buffer(buffer, opts)
    opts = opts or {}
    local force = opts.force ~= false

    vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buffer) then
            if vim.bo[buffer].filetype == "neo-tree" then
                return
            end

            if vim.bo[buffer].modified and not force then
                vim.api.nvim_err_writeln("No write since last change (add ! to override)")
                return
            end

            local replacement = nil

            for _, listed_buffer in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
                if listed_buffer.bufnr ~= buffer and vim.api.nvim_buf_is_valid(listed_buffer.bufnr) then
                    replacement = listed_buffer.bufnr
                    break
                end
            end

            if replacement == nil then
                replacement = vim.api.nvim_create_buf(true, false)
            end

            for _, window in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_is_valid(window) and vim.api.nvim_win_get_buf(window) == buffer then
                    vim.api.nvim_win_set_buf(window, replacement)
                end
            end

            pcall(vim.api.nvim_buf_delete, buffer, { force = force })
        end
    end)
end

function M.close_all_buffers(opts)
    opts = opts or {}
    local force = opts.force == true
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })

    if not force then
        for _, buffer_info in ipairs(buffers) do
            if vim.api.nvim_buf_is_valid(buffer_info.bufnr) and vim.bo[buffer_info.bufnr].modified then
                vim.api.nvim_err_writeln("No write since last change (add ! to override)")
                return
            end
        end
    end

    local replacement = vim.api.nvim_create_buf(true, false)

    for _, window in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(window) then
            local buffer = vim.api.nvim_win_get_buf(window)
            if vim.bo[buffer].filetype ~= "neo-tree" then
                vim.api.nvim_win_set_buf(window, replacement)
            end
        end
    end

    for _, buffer_info in ipairs(buffers) do
        local buffer = buffer_info.bufnr
        if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].filetype ~= "neo-tree" and buffer ~= replacement then
            pcall(vim.api.nvim_buf_delete, buffer, { force = force })
        end
    end
end

return M

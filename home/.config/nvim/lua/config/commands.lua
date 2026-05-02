local buffers = require("config.buffers")
local git = require("config.git")

vim.api.nvim_create_user_command("NvimCheatsheet", function()
    local cheatsheet_path = vim.fn.stdpath("config") .. "/CHEATSHEET.md"
    vim.cmd("edit " .. vim.fn.fnameescape(cheatsheet_path))
    vim.bo.filetype = "markdown"
end, { desc = "Open Neovim cheatsheet" })

vim.keymap.set("n", "<leader>hc", "<cmd>NvimCheatsheet<CR>", { desc = "Open cheatsheet" })

vim.api.nvim_create_user_command("Bclose", function(opts)
    buffers.close_buffer(vim.api.nvim_get_current_buf(), { force = opts.bang })
end, { bang = true, desc = "Close current buffer" })

vim.api.nvim_create_user_command("BwriteClose", function(opts)
    buffers.write_close_buffer(vim.api.nvim_get_current_buf(), { force = opts.bang })
end, { bang = true, desc = "Write and close current buffer" })

vim.api.nvim_create_user_command("BcloseAll", function(opts)
    buffers.close_all_buffers({ force = opts.bang })
end, { bang = true, desc = "Close all buffers" })

vim.api.nvim_create_user_command("Bdelete", function(opts)
    local buffer = vim.api.nvim_get_current_buf()
    if vim.bo[buffer].filetype == "neo-tree" then
        vim.api.nvim_err_writeln("Use <leader>ef or <leader>eg for Neo-tree")
        return
    end

    buffers.close_buffer(buffer, { force = opts.bang })
end, { bang = true, desc = "Delete current buffer" })

vim.api.nvim_create_user_command("NvimExit", function(opts)
    vim.cmd(opts.bang and "quitall!" or "confirm quitall")
end, { bang = true, desc = "Quit Neovim" })

vim.cmd([[
cnoreabbrev <expr> q getcmdtype() ==# ':' && getcmdline() ==# 'q' ? 'Bclose' : 'q'
cnoreabbrev <expr> q! getcmdtype() ==# ':' && getcmdline() ==# 'q!' ? 'Bclose!' : 'q!'
cnoreabbrev <expr> wq getcmdtype() ==# ':' && getcmdline() ==# 'wq' ? 'BwriteClose' : 'wq'
cnoreabbrev <expr> wq! getcmdtype() ==# ':' && getcmdline() ==# 'wq!' ? 'BwriteClose!' : 'wq!'
cnoreabbrev <expr> x getcmdtype() ==# ':' && getcmdline() ==# 'x' ? 'BwriteClose' : 'x'
cnoreabbrev <expr> x! getcmdtype() ==# ':' && getcmdline() ==# 'x!' ? 'BwriteClose!' : 'x!'
cnoreabbrev <expr> qa getcmdtype() ==# ':' && getcmdline() ==# 'qa' ? 'BcloseAll' : 'qa'
cnoreabbrev <expr> qa! getcmdtype() ==# ':' && getcmdline() ==# 'qa!' ? 'BcloseAll!' : 'qa!'
cnoreabbrev <expr> qall getcmdtype() ==# ':' && getcmdline() ==# 'qall' ? 'BcloseAll' : 'qall'
cnoreabbrev <expr> qall! getcmdtype() ==# ':' && getcmdline() ==# 'qall!' ? 'BcloseAll!' : 'qall!'
cnoreabbrev <expr> exit getcmdtype() ==# ':' && getcmdline() ==# 'exit' ? 'NvimExit' : 'exit'
cnoreabbrev <expr> exit! getcmdtype() ==# ':' && getcmdline() ==# 'exit!' ? 'NvimExit!' : 'exit!'
cnoreabbrev <expr> bd getcmdtype() ==# ':' && getcmdline() ==# 'bd' ? 'Bdelete' : 'bd'
cnoreabbrev <expr> bd! getcmdtype() ==# ':' && getcmdline() ==# 'bd!' ? 'Bdelete!' : 'bd!'
cnoreabbrev <expr> bdelete getcmdtype() ==# ':' && getcmdline() ==# 'bdelete' ? 'Bdelete' : 'bdelete'
cnoreabbrev <expr> bdelete! getcmdtype() ==# ':' && getcmdline() ==# 'bdelete!' ? 'Bdelete!' : 'bdelete!'
]])

git.setup()

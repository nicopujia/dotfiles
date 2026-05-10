return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave", "BufNewFile" },
    config = function()
        local lint = require("lint")

        local function project_root(file)
            local start = file
            if file == "" then
                start = vim.loop.cwd()
            else
                start = vim.fs.dirname(file)
            end
            local root = vim.fs.root(start, { "package.json", "biome.json", "biome.jsonc", ".eslintrc", ".eslintrc.json",
                ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.ts", "turbo.json" })
            if not root then
                return vim.loop.cwd()
            end
            return root
        end

        local function local_bin(root, name)
            local candidates = {
                root .. "/node_modules/.bin/" .. name,
                root .. "/node_modules/.bin/" .. name .. ".cmd",
            }
            for _, candidate in ipairs(candidates) do
                if vim.fn.executable(candidate) == 1 then
                    return candidate
                end
            end
            if vim.fn.executable(name) == 1 then
                return name
            end
            return nil
        end

        local function available_linters(root)
            local linters = {}
            local prefers_biome = vim.fn.filereadable(root .. "/biome.json") == 1 or vim.fn.filereadable(root .. "/biome.jsonc") == 1
            local ordered = {}

            if prefers_biome then
                table.insert(ordered, "biome")
            end

            if not prefers_biome and vim.fn.filereadable(root .. "/turbo.json") == 1 then
                table.insert(ordered, "biome")
            end
            table.insert(ordered, "eslint_d")
            table.insert(ordered, "eslint")

            for _, name in ipairs(ordered) do
                local linter = lint.linters[name]
                if linter then
                    local cmd = local_bin(root, name)
                    if cmd then
                        linter.cmd = cmd
                        table.insert(linters, name)
                    end
                end
            end
            return linters
        end

        local function bind_linters(filetype, root)
            local linters = available_linters(root)
            if #linters == 0 then
                return false
            end
            lint.linters_by_ft[filetype] = linters
            return true
        end

        local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
            group = group,
            callback = function()
                local ft = vim.bo.filetype
                local root = project_root(vim.api.nvim_buf_get_name(0))
                if ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" then
                    if not bind_linters(ft, root) then
                        return
                    end
                    lint.try_lint()
                end
            end,
        })
    end,
}

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            vim.lsp.config("ty", {
                capabilities = capabilities,
                settings = {
                    ty = {},
                },
            })

            vim.lsp.config("ruff", {
                capabilities = capabilities,
            })

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                    },
                },
            })
        end,
    },
    {
        "mason-org/mason.nvim",
        name = "mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "ruff", "lua_ls" },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition,
                        vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                    vim.keymap.set("n", "K", vim.lsp.buf.hover,
                        vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
                    vim.keymap.set("n", "gr", vim.lsp.buf.references,
                        vim.tbl_extend("force", opts, { desc = "Go to references" }))
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
                        vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
                        vim.tbl_extend("force", opts, { desc = "Code action" }))
                    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format,
                        vim.tbl_extend("force", opts, { desc = "Format buffer" }))
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
                        vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
                        vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                end,
            })

            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.py",
                callback = function()
                    vim.lsp.buf.format({
                        async = false,
                        filter = function(client)
                            return client.name == "ruff"
                        end,
                    })
                end,
            })

            vim.lsp.enable({ "ty", "ruff", "lua_ls" })
        end,
    },
}

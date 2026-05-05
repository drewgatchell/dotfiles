return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "gopls",
                "rust_analyzer",
                "ty",
                "ts_ls",
                "lua_ls",
                "terraformls",
                "yamlls",
                "jsonls",
                "bashls",
            },
            automatic_enable = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp" },
        config = function()
            -- Wire blink.cmp's enhanced completion capabilities into every server
            vim.lsp.config("*", {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
            })

            -- Per-server overrides
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })

            -- Buffer-local LSP keymaps, set only when an LSP attaches
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local map_opts = { buffer = args.buf, silent = true }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, map_opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, map_opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, map_opts)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, map_opts)
                    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, map_opts)
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, map_opts)
                end,
            })

            -- Diagnostic UI
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })
        end,
    },
}

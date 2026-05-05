return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()

            local languages = {
                "python",
                "go",
                "rust",
                "javascript",
                "typescript",
                "tsx",
                "hcl",       -- Terraform
                "yaml",
                "json",
                "lua",
                "markdown",
                "bash",
            }

            require("nvim-treesitter").install(languages)

            local filetypes = {}
            for _, lang in ipairs(languages) do
                for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
                    table.insert(filetypes, ft)
                end
            end

            vim.api.nvim_create_autocmd("FileType", {
                pattern = filetypes,
                callback = function()
                    vim.treesitter.start()
                    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo[0][0].foldmethod = "expr"
                end,
            })
        end,
    },
}

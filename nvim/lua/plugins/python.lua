return {
  -- Swap LazyVim's default basedpyright for Astral's ty
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = { enabled = false },
        ty = {},
      },
    },
  },
}

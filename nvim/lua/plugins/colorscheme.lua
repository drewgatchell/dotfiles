return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_bg = false,
      italic_comment = true,
    },
  },
  -- Tell LazyVim to use dracula instead of tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "moon",
      dark_variant = "moon",
      styles = {
        bold = true,
        italic = false,
        transparency = false,
      },
      highlight_groups = {
        LspReferenceText = { bg = "none" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    lazy = false,
    opts = {
      colorscheme = "rose-pine",
    },
  },
}

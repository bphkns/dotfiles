return {
  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        identifiers = { italic = false },
        functions = {},
        variables = {},
      },
      gamma = 0.8,
      custom_highlights = function(hl)
        hl.LspReferenceText = {
          bg = "none",
        }
        hl["@text.emphasis"] = {
          italic = false,
        }

        return {}
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyodark",
    },
  },
}

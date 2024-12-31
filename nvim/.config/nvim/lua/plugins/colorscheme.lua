return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "moon",
      on_highlights = function(hl, c)
        hl.LspReferenceText = {
          bg = "none",
        }
      end,
    },
  },
}

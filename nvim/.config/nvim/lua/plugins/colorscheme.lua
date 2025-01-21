return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      on_highlights = function(hl, c)
        hl.LspReferenceText = {
          bg = "none",
        }
      end,
    },
  },
}

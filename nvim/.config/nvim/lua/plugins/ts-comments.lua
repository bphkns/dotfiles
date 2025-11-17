return {
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    config = function()
      require("ts-comments").setup({
        lang = {
          angular = {
            "<!-- %s -->",
          },
        },
      })
    end,
  },
}

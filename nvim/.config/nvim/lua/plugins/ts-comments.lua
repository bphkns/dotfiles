return {
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    config = function()
      require("ts-comments").setup({
        lang = {
          angular = {
            "<!-- %s -->", -- Default to HTML comments
          },
        }
      })
    end,
  }
}

return {
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        italic = {
          strings = false,
          emphasis = false,
          operators = false,
        },
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },

}

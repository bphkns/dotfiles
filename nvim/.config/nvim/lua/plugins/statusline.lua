return {
  {
    "nvim-lualine/lualine.nvim",
    version = "*",
    event = { "VeryLazy" },
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local gruvbox = require("lualine.themes.gruvbox")
      require("lualine").setup({
        options = {
          theme = gruvbox,
        },
      })
    end,
  },
}

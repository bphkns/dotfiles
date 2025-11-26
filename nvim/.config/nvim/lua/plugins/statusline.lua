return {
  {
    "nvim-lualine/lualine.nvim",
    version = "*",
    event = { "VeryLazy" },
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local lualine = require('lualine')
      lualine.setup({
        options = {
          theme = 'gruvbox-material'
        }
      })
    end,
  },
}

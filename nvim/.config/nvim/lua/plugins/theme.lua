return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
        styles = {
          bold = true,
          italic = false,
          transparency = false,
        },
        -- highlight_groups = {
        --   LspReferenceText = { bg = "none" },
        -- },
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "ColorScheme",
    config = function()
      local highlights = require("rose-pine.plugins.bufferline")
      require("bufferline").setup({ highlights = highlights })
    end,
  },
}

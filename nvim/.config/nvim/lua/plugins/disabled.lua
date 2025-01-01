return {
  {
    "rcarriga/nvim-notify",
    enabled = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        hover = { silent = true },
      },
    },
  },
}

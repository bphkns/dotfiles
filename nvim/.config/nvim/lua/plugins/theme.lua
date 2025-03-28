return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
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
}

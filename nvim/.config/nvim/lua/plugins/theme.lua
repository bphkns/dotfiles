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
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   name = "onedarkpro",
  --   priority = 1000,
  --   lazy = false,
  --   config = function()
  --     require("onedarkpro").setup({
  --     })
  --     vim.cmd("colorscheme vaporwave")
  --   end,
  -- }
}

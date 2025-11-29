return {
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("rose-pine").setup({
  --       variant = "moon",
  --       dark_variant = "moon",
  --       styles = {
  --         bold = true,
  --         italic = false,
  --         transparency = true,
  --       },
  --     })
  --     vim.cmd("colorscheme rose-pine")
  --   end,
  -- },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = false,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false,
        },
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
}

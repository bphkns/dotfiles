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
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   name = "gruvbox",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("gruvbox").setup({
  --       contrast = "hard",
  --       transparent_mode = false,
  --       italic = {
  --         strings = false,
  --         emphasis = false,
  --         comments = false,
  --         operators = false,
  --         folds = false,
  --       },
  --     })
  --     vim.cmd("colorscheme gruvbox")
  --   end,
  -- },
  {
    "tiagovla/tokyodark.nvim",
    lazy     = false,
    priority = 1000,
    opts     = {
      transparent_background = false,
      gamma = 1.00,
      styles = {
        comments = { italic = true },
        keywords = {},
        identifiers = {},
        functions = {},
        variables = {},
      },
      terminal_colors = true,
    },
    config   = function(_, opts)
      require("tokyodark").setup(opts)
      vim.cmd [[colorscheme tokyodark]]
    end,
  }
}

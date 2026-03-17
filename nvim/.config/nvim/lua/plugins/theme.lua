return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configure Everforest
      vim.g.everforest_background = 'soft'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_dim_inactive_windows = 1
      
      -- Apply colorscheme
      vim.cmd('colorscheme everforest')
    end,
  },
}

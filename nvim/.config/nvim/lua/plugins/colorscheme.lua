return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "main", -- auto, main, moon, or dawn
      dark_variant = "main", -- main, moon, or dawn
      styles = {
        transparency = true,
      },
      highlight_groups = {
        NormalFloat = { bg = "#000000", blend = 100, inherit = true },
        TelescopeBorder = { fg = "overlay", bg = "overlay" },
        TelescopeNormal = { fg = "subtle", bg = "overlay" },
        TelescopeSelection = { fg = "text", bg = "highlight_med" },
        TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
        TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

        TelescopeTitle = { fg = "base", bg = "love" },
        TelescopePromptTitle = { fg = "base", bg = "pine" },
        TelescopePreviewTitle = { fg = "base", bg = "iris" },

        TelescopePromptNormal = { fg = "text", bg = "surface" },
        TelescopePromptBorder = { fg = "surface", bg = "surface" },
        LspReferenceText = { bg = "none" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    lazy = false,
    opts = {
      colorscheme = "rose-pine",
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "ColorScheme",
    opts = function(_, opts)
      local highlights = require("rose-pine.plugins.bufferline")
      opts.highlights = highlights
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "ColorScheme",
    opts = {
      options = {
        --- @usage 'rose-pine' | 'rose-pine-alt'
        theme = "rose-pine",
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
      },
    },
  },
}

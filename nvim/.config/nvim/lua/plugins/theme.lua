return {
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "vulgaris",
      transparent = false,
      dim_inactive = false,
      term_colors = true,
      code_style = {},
      highlights = {
        -- WhichKey
        WhichKey = { fg = "#e75a7c" },
        WhichKeyGroup = { fg = "#57a5e5" },
        WhichKeyDesc = { fg = "#f1e9d2" },
        WhichKeySeparator = { fg = "#5b5e5a" },
        WhichKeyNormal = { bg = "#2f312c" },
        WhichKeyBorder = { fg = "#57a5e5", bg = "#2f312c" },
        WhichKeyValue = { fg = "#5b5e5a" },
      },
    },
    config = function(_, opts)
      require("bamboo").setup(opts)
      require("bamboo").load()
    end,
  },
}

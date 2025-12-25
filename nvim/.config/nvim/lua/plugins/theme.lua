return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "soft",
      transparent_mode = false,
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
      overrides = {
        -- Noice
        NoiceCmdlinePopup = { bg = "#3c3836" },
        NoiceCmdlinePopupBorder = { fg = "#83a598", bg = "#3c3836" },
        NoiceCmdlinePopupTitle = { fg = "#83a598", bg = "#3c3836" },
        NoiceCmdlineIcon = { fg = "#fabd2f" },
        NoicePopup = { bg = "#3c3836" },
        NoicePopupBorder = { fg = "#83a598", bg = "#3c3836" },
        NoicePopupmenu = { bg = "#3c3836" },
        NoicePopupmenuBorder = { fg = "#83a598", bg = "#3c3836" },
        NoicePopupmenuSelected = { bg = "#504945" },

        -- WhichKey
        WhichKey = { fg = "#fb4934" },
        WhichKeyGroup = { fg = "#83a598" },
        WhichKeyDesc = { fg = "#ebdbb2" },
        WhichKeySeparator = { fg = "#928374" },
        WhichKeyNormal = { bg = "#3c3836" },
        WhichKeyBorder = { fg = "#83a598", bg = "#3c3836" },
        WhichKeyValue = { fg = "#928374" },

        -- Float windows
        NormalFloat = { bg = "#3c3836" },
        FloatBorder = { fg = "#83a598", bg = "#3c3836" },
        FloatTitle = { fg = "#fabd2f", bg = "#3c3836" },
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}

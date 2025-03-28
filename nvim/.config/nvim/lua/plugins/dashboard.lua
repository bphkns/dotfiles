return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
      "echasnovski/mini.icons",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("alpha").setup(require("alpha.themes.theta").config)
    end,
  },
}

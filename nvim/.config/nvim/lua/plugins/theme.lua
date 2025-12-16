return {
  {
    "uhs-robert/oasis.nvim",
    name = "oasis",
    lazy = false,
    priority = 1000,
    config = function()
      require("oasis").setup()
      vim.cmd.colorscheme("oasis-abyss")
    end,
  },
}

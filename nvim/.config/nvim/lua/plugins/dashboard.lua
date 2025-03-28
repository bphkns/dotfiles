return {
  {
    "echasnovski/mini.starter",
    version = "*",
    dependencies = { "echasnovski/mini.icons", version = "*" },
    event = "VimEnter",
    config = function()
      require("mini.starter").setup({})
    end,
  },
}

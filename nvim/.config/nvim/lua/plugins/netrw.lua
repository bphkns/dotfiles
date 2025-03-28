vim.g.netrw_liststyle = 3

return {
  {
    "prichrd/netrw.nvim",
    opts = {},
    event = { "VeryLazy" },
    config = function()
      require("netrw").setup({
        use_devicons = true,
      })
    end,
  },
}

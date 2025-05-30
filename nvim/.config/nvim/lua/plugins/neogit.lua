return {

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua", },
    lazy = false,
    config = function()
      require("neogit").setup {}

      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>")
    end,
  }

}

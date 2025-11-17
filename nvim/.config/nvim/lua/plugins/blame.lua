return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    config = function()
      require("gitblame").setup({
        enabled = false,
        gitblame_display_virtual_text = 0,
      })

      local opts = { noremap = true, silent = true, desc = "" }

      vim.keymap.set(
        "n",
        "<leader>gb",
        "<cmd>GitBlameToggle<CR>",
        vim.tbl_extend("force", opts, { desc = "Toggle git blame display" })
      )

      vim.keymap.set(
        "n",
        "<leader>gc",
        "<cmd>GitBlameCopySHA<CR>",
        vim.tbl_extend("force", opts, { desc = "Copy commit SHA" })
      )

      vim.keymap.set(
        "n",
        "<leader>gC",
        "<cmd>GitBlameCopyCommitURL<CR>",
        vim.tbl_extend("force", opts, { desc = "Copy commit URL" })
      )

      vim.keymap.set(
        "n",
        "<leader>gf",
        "<cmd>GitBlameCopyFileURL<CR>",
        vim.tbl_extend("force", opts, { desc = "Copy file URL at commit" })
      )

      vim.keymap.set(
        "n",
        "<leader>gB",
        "<cmd>GitBlameOpenCommitURL<CR>",
        vim.tbl_extend("force", opts, { desc = "Open commit in browser" })
      )

      vim.keymap.set(
        "n",
        "<leader>gF",
        "<cmd>GitBlameOpenFileURL<CR>",
        vim.tbl_extend("force", opts, { desc = "Open file in browser" })
      )
    end,
  },
}

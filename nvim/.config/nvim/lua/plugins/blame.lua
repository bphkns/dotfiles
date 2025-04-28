return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true, -- if you want to enable the plugin
      message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
      date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    },
    config = function(_, opt)
      require("gitblame").setup(opt)

      local opts = { noremap = true, silent = true, desc = "" }

      -- 3) Toggle / enable / disable blame virtual text
      vim.keymap.set(
        "n",
        "<leader>gb",
        "<cmd>GitBlameToggle<CR>",
        vim.tbl_extend("force", opts, { desc = "Toggle git blame display" })
      ) -- Toggle blame :contentReference[oaicite:0]{index=0}
      vim.keymap.set(
        "n",
        "<leader>ge",
        "<cmd>GitBlameEnable<CR>",
        vim.tbl_extend("force", opts, { desc = "Enable git blame" })
      ) -- Enable blame :contentReference[oaicite:1]{index=1}
      vim.keymap.set(
        "n",
        "<leader>gd",
        "<cmd>GitBlameDisable<CR>",
        vim.tbl_extend("force", opts, { desc = "Disable git blame" })
      ) -- Disable blame :contentReference[oaicite:2]{index=2}

      -- 4) Copy SHA / URLs
      vim.keymap.set(
        "n",
        "<leader>gc",
        "<cmd>GitBlameCopySHA<CR>",
        vim.tbl_extend("force", opts, { desc = "Copy commit SHA" })
      ) -- Copy SHA :contentReference[oaicite:3]{index=3}
      vim.keymap.set(
        "n",
        "<leader>gC",
        "<cmd>GitBlameCopyCommitURL<CR>",
        vim.tbl_extend("force", opts, { desc = "Copy commit URL" })
      ) -- Copy commit URL :contentReference[oaicite:4]{index=4}
      vim.keymap.set(
        "n",
        "<leader>gf",
        "<cmd>GitBlameCopyFileURL<CR>",
        vim.tbl_extend("force", opts, { desc = "Copy file URL at commit" })
      ) -- Copy file URL :contentReference[oaicite:5]{index=5}

      -- 5) Browse commit / file in browser (avoids <leader>go)
      vim.keymap.set(
        "n",
        "<leader>gB",
        "<cmd>GitBlameOpenCommitURL<CR>",
        vim.tbl_extend("force", opts, { desc = "Open commit in browser" })
      ) -- Browse commit :contentReference[oaicite:6]{index=6}
      vim.keymap.set(
        "n",
        "<leader>gF",
        "<cmd>GitBlameOpenFileURL<CR>",
        vim.tbl_extend("force", opts, { desc = "Open file in browser" })
      ) -- Browse file :contentReference[oaicite:7]{index=7}
    end,
  },
}

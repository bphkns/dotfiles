return {
  "nvim-telescope/telescope.nvim",
  keys = function()
    return {
      { "<leader> ", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      -- shortcut for opening recent files in current root directory
      {
        "<C-p>",
        function()
          require("telescope.builtin").oldfiles({ cwd_only = true })
        end,
        desc = "Recent in current directory",
      },
      -- Ctrl+F for fuzzy search in current buffer
      {
        "<C-f>",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Fuzzy search in current buffer",
      },
    }
  end,
}

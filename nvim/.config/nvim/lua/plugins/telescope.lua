return {
  "nvim-telescope/telescope.nvim",
  -- replace all Telescope keymaps with only one mapping
  keys = function()
    return {
      { "<leader> ", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      -- shortcut for opening recent files
      {
        "<C-p>",
        "<cmd>Telescope oldfiles<cr>",
        desc = "Recent",
      },
    }
  end,
}

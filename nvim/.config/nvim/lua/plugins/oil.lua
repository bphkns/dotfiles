return {
  {
    "stevearc/oil.nvim",
    dependencies = { "echasnovski/mini.icons", version = "*" },
    event = { "VeryLazy" },
    keys = {
      {
        "<leader>o",
        function()
          require("oil").open()
        end,
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      skip_confirm_for_simple_edits = true,
      win_options = {
        wrap = true,
      },
    },
  },
}

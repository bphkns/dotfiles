return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    opts = {
      -- add any opts here
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      {
        "grapp-dev/nui-components.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
      },
      --- The below is optional, make sure to setup it properly if you have lazy=true
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").add({
        mode = { "n", "v" },
        nowait = true,
        remap = false,
        {
          "<localleader>co",
          "<cmd>AvanteConflictChooseOurs<cr>",
          desc = "Avanate Choose Ours",
        },
        {
          "<localleader>ct",
          "<cmd>AvanteConflictChooseTheirs<cr>",
          desc = "Avante Choose Theirs",
        },
        {
          "<localleader>c0",
          "<cmd>AvanteConflictNone<cr>",
          desc = "Avante Choose None",
        },
        {
          "<localleader>cb",
          "<cmd>AvanteConflictBoth<cr>",
          desc = "Avante Choose Both",
        },
      })
    end,
  },
}

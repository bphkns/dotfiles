return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 300,
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
      spec = {
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>x", group = "Trouble" },
        { "<leader>s", group = "Swap" },
        { "<leader>i", group = "Info/Toggle" },
        { "<leader>d", group = "Document" },
        { "<leader>w", group = "Workspace" },
        { "<leader>r", group = "Rename" },
        { "<leader>t", group = "Test" },
        { "<leader>a", group = "AI" },
        { "<leader>z", group = "Folds" },
        { "<leader>m", group = "MJML" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps",
      },
    },
  },
}

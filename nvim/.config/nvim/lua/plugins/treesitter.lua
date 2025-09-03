return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "angular",
          "tsx",
          "typescript",
          "html",
          "yaml",
          "json",
          "css",
          "scss",
          "sql",
          "dockerfile",
          "prisma",
        },
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = false },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
  { "nvim-treesitter/playground" },
}

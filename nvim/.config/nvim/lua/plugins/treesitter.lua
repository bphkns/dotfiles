return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
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
      })
    end,
  },
  { "nvim-treesitter/playground" },
}

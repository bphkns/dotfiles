return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
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
      vim.filetype.add({
        extension = {
          perm = "perm",
        },
      })
    end,
  },
  { "nvim-treesitter/playground" },
  {
    "nvim-treesitter",
    opts = function()
      vim.filetype.add({
        pattern = {
          [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `htmlangular` if it matches the pattern
        },
      })
    end,
  },
}

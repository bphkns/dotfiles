return {
  { "nvim-treesitter/playground" },
  {
    "nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
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
      end
      vim.filetype.add({
        pattern = {
          [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `htmlangular` if it matches the pattern
        },
      })
    end,
  },
}

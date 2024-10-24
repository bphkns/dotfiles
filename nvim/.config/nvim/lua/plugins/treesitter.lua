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
      vim.filetype.add({
        extension = {
          perm = "perm",
        },
      })

      vim.treesitter.language.register("perm", "perm")
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.perm = {
        install_info = {
          url = "https://github.com/theoriginalstove/tree-sitter-perm", -- local path or git repo
          files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
          branch = "main",
        },
      }
    end,
  },
  { "nvim-treesitter/playground" },
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.filetype.add({
        pattern = {
          [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `htmlangular` if it matches the pattern
        },
      })
    end,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      ensure_installed = {
        "nxls",
        "angularls",
      },
      servers = {
        angularls = {
          root_dir = require("lspconfig").util.root_pattern("angular.json", "project.json"),
          filetypes = { "angular", "html", "typescript", "typescriptreact" },
        },
        vtsls = {
          settings = {
            complete_function_calls = false,
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
    },
  },
}

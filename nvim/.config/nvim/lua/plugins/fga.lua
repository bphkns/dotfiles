local openfga_lsp_dir = vim.fn.stdpath("data") .. "/lazy/openfga-vscode-ext"

return {
  {
    "openfga/vscode-ext",
    name = "openfga-vscode-ext",
    build = "npm install && npm run compile",
    lazy = true,
  },
  {
    "hedengran/fga.nvim",
    dependencies = { "openfga-vscode-ext" },
    lazy = false,
    opts = {
      lsp_cmd = { "node", openfga_lsp_dir .. "/server/out/server.node.js", "--stdio" },
    },
  },
}

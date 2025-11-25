return {
  -- Copilot LSP enhancements (NES support for Sidekick)
  -- Server configured in lsp.lua, install via :MasonInstall copilot-language-server
  {
    "copilotlsp-nvim/copilot-lsp",
    lazy = false,
    init = function()
      vim.g.copilot_nes_debounce = 500
    end,
    config = function()
      require("copilot-lsp").setup({
        nes = {
          move_count_threshold = 3,
        },
      })
    end,
  },
  -- Copilot.lua (for auth and blink-cmp integration)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
      },
    },
  },
}

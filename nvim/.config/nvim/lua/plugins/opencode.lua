return {
  "sudo-tee/opencode.nvim",
  keys = {
    { "<leader>ag", desc = "Toggle opencode" },
    { "<leader>ai", desc = "Open input (current session)" },
    { "<leader>aI", desc = "Open input (new session)" },
    { "<leader>ao", desc = "Open output window" },
    { "<leader>at", desc = "Toggle focus" },
    { "<leader>aq", desc = "Close opencode" },
    { "<leader>as", desc = "Select session" },
    { "<leader>ad", desc = "Open diff view" },
  },
  config = function()
    require("opencode").setup({
      keymap_prefix = "<leader>a",
      preferred_completion = "blink",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "MeanderingProgrammer/render-markdown.nvim",
          opts = {
            anti_conceal = { enabled = false },
            file_types = { "markdown", "opencode_output" },
          },
          ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
        },
        "saghen/blink.cmp",
        "ibhagwan/fzf-lua",
      },
    })
  end,
  preferred_picker = "fzf",
}

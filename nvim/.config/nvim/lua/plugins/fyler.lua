return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  branch = "stable",
  lazy = false,
  opts = {
    views = {
      finder = {
        win = {
          kind = "float",
        },
        mappings = {
          ["<C-e>"] = "CloseView", -- toggle close with same key
        },
      },
    },
  },
  config = function(_, opts)
    local fyler = require("fyler")
    fyler.setup(opts)
    vim.keymap.set("n", "<C-e>", function()
      fyler.toggle({ kind = "float", dir = vim.fn.getcwd() })
    end, { desc = "Toggle Explorer" })
  end,
}

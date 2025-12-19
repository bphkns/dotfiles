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
      },
    },
  },
  keys = {
    {
      "<C-e>",
      function()
        require("fyler").open({ kind = "float" })
      end,
      desc = "Toggle Explorer",
    },
  },
}

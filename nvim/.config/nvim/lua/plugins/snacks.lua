return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[
              ███╗   ██╗██╗   ██╗██╗███╗   ███╗
              ████╗  ██║██║   ██║██║████╗ ████║
              ██╔██╗ ██║██║   ██║██║██╔████╔██║
              ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
              ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
              ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
          keys = {
            { icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
            { icon = " ", key = "f", desc = "Find file", action = ":FzfLua files" },
            { icon = " ", key = "r", desc = "Recent files", action = ":FzfLua oldfiles" },
            { icon = " ", key = "g", desc = "Find text", action = ":FzfLua live_grep" },
            { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      quickfile = { enabled = true },
      bigfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      bufdelete = { enabled = true },
    },
    keys = {
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },
    },
  },
}

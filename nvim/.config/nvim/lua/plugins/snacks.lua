return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
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
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "recent_files", title = "MRU", limit = 10, padding = 1, cwd = true },
          { section = "recent_files", title = "MRU (Global)", limit = 5, padding = 1, cwd = false },
          { section = "startup" },
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

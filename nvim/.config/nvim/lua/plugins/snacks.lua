---@module "snacks"

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        width = 70,
        preset = {
          header = [[
                  ·
           ╭───────────╮
      ─────╯           ╰─────
              N V I M
      ─────╮           ╭─────
           ╰───────────╯
                  ·]],
          keys = {
            { key = "e", action = ":ene | startinsert", hidden = true },
            { key = "f", action = ":FzfLua files", hidden = true },
            { key = "r", action = ":FzfLua oldfiles", hidden = true },
            { key = "g", action = ":FzfLua live_grep", hidden = true },
            { key = "c", action = ":e $MYVIMRC", hidden = true },
            { key = "l", action = ":Lazy", hidden = true },
            { key = "q", action = ":qa", hidden = true },
          },
        },
        sections = {
          { section = "header" },
          function()
            return {
              text = {
                { "󰉋  ", hl = "SnacksDashboardIcon" },
                { vim.fn.fnamemodify(vim.fn.getcwd(), ":~"), hl = "SnacksDashboardDir" },
              },
              align = "center",
              padding = { 1, 1 },
            }
          end,
          {
            text = {
              { "[f]", hl = "SnacksDashboardKey" },
              { " files    ", hl = "SnacksDashboardDesc" },
              { "[g]", hl = "SnacksDashboardKey" },
              { " grep    ", hl = "SnacksDashboardDesc" },
              { "[e]", hl = "SnacksDashboardKey" },
              { " new    ", hl = "SnacksDashboardDesc" },
              { "[c]", hl = "SnacksDashboardKey" },
              { " config", hl = "SnacksDashboardDesc" },
            },
            align = "center",
            padding = { 1, 1 },
          },
          { section = "keys" },
          { icon = " ", title = "Return", section = "recent_files", cwd = true, limit = 8, indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", limit = 3, indent = 2, padding = 1 },
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

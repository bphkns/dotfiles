local start_time = os.time()

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-mini/mini.icons",
    },
    config = function()
      local function session_time()
        local elapsed = os.time() - start_time
        local hours = math.floor(elapsed / 3600)
        local mins = math.floor((elapsed % 3600) / 60)
        if hours > 0 then
          return string.format("󰥔 %dh %dm", hours, mins)
        else
          return string.format("󰥔 %dm", mins)
        end
      end

      local colors = {
        bg = "#282828",
        fg = "#ebdbb2",
        yellow = "#fabd2f",
        orange = "#fe8019",
        aqua = "#8ec07c",
        blue = "#83a598",
        red = "#fb4934",
        gray = "#504945",
      }

      local custom_theme = {
        normal = {
          a = { bg = colors.orange, fg = colors.bg, gui = "bold" },
          b = { bg = colors.gray, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
          z = { bg = colors.aqua, fg = colors.bg, gui = "bold" },
        },
        insert = {
          a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
          z = { bg = colors.aqua, fg = colors.bg, gui = "bold" },
        },
        visual = {
          a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
          z = { bg = colors.aqua, fg = colors.bg, gui = "bold" },
        },
        replace = {
          a = { bg = colors.red, fg = colors.bg, gui = "bold" },
          z = { bg = colors.aqua, fg = colors.bg, gui = "bold" },
        },
        command = {
          a = { bg = colors.aqua, fg = colors.bg, gui = "bold" },
          z = { bg = colors.orange, fg = colors.bg, gui = "bold" },
        },
        inactive = {
          a = { bg = colors.gray, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.gray },
        },
      }

      require("lualine").setup({
        options = {
          theme = custom_theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
          lualine_b = { { "filename", path = 0, symbols = { modified = " [-]", readonly = " [RO]" } } },
          lualine_c = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
              colored = true,
            },
          },
          lualine_x = {
            "encoding",
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
            },
            "branch",
            "filetype",
          },
          lualine_y = { session_time, "progress" },
          lualine_z = { { "location", separator = { left = "", right = "" }, left_padding = 2 } },
        },
        inactive_sections = {
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
        },
      })
    end,
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-mini/mini.icons",
      "ellisonleao/gruvbox.nvim",
    },
    config = function()
      local colors = require("gruvbox").palette
      local theme = {
        normal = {
          a = { bg = colors.bright_blue, fg = colors.dark0, gui = "bold" },
          b = { bg = colors.dark2, fg = colors.light1 },
          c = { bg = colors.dark1, fg = colors.light4 },
        },
        insert = {
          a = { bg = colors.bright_green, fg = colors.dark0, gui = "bold" },
        },
        visual = {
          a = { bg = colors.bright_orange, fg = colors.dark0, gui = "bold" },
        },
        replace = {
          a = { bg = colors.bright_red, fg = colors.dark0, gui = "bold" },
        },
        command = {
          a = { bg = colors.bright_yellow, fg = colors.dark0, gui = "bold" },
        },
        inactive = {
          a = { bg = colors.dark1, fg = colors.light4 },
          b = { bg = colors.dark1, fg = colors.light4 },
          c = { bg = colors.dark1, fg = colors.light4 },
        },
      }
      require("lualine").setup({
        options = {
          theme = theme,
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
            {
              function()
                local ok, copilot = pcall(require, "copilot.api")
                if not ok then return "" end
                local status = copilot.status.data.status
                if status == "InProgress" then return " " end
                if status == "Normal" then return " " end
                if status == "Warning" then return " " end
                return " "
              end,
              cond = function()
                return pcall(require, "copilot.api")
              end,
            },
            "diagnostics",
          },
          lualine_y = { "filetype" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
        },
      })
    end,
  },
}

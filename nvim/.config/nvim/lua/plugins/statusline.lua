local colors = {
  blue = "#80a0ff",
  cyan = "#79dac8",
  black = "#080808",
  white = "#c6c6c6",
  red = "#ff5189",
  violet = "#d183e8",
  grey = "#303030",
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    version = "*",
    event = { "VeryLazy" },
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = bubbles_theme,
          component_separators = "",
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_b = { "branch", "selectionCount", "diff" },
          lualine_c = {
            "%=",
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then
                  return "Recording @" .. reg
                else
                  return "" -- Or return nil if you want the component to be hidden when not recording
                end
              end,
              -- You can add styling if you like
              color = { fg = "#ff9e64" }, -- Example: a warm orange color
              draw_empty = false,         -- Set to true if you want the component to always be drawn, even when empty
            },

          },
          lualine_x = { "searchcount" },
          lualine_y = { "filetype", "progress" },
          lualine_z = {
            { "location", separator = { right = "" }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { "filename" },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
        tabline = {
          lualine_a = { "filename", },
          lualine_b = {
            'diagnostics'
          },
          lualine_x = {
            { "filename", path = 1 },
          },
        },
        extensions = {},
      })
    end,
  },
}

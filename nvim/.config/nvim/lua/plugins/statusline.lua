local start_time = os.time()

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "echasnovski/mini.icons",
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

      require("lualine").setup({
        options = {
          theme = "auto",
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

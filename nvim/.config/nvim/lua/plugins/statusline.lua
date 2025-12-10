return {
  {
    "nvim-mini/mini.statusline",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-mini/mini.icons" },
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({
        use_icons = true,
      })

      -- Apply Gruvbox colors to statusline
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox",
        callback = function()
          -- Gruvbox dark medium contrast colors
          local bg0 = "#282828"  -- main background
          local bg1 = "#32302f"  -- slightly lighter (medium contrast bg1)
          local fg = "#d5c4a1"   -- medium contrast foreground
          local gray = "#928374"
          
          -- Gruvbox accent colors (dark variants for medium contrast)
          local green = "#98971a"
          local blue = "#458588"
          local orange = "#d65d0e"
          local red = "#cc241d"
          local yellow = "#d79921"
          local purple = "#b16286"

          vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = bg0, bg = green, bold = true })
          vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = bg0, bg = blue, bold = true })
          vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = bg0, bg = orange, bold = true })
          vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = bg0, bg = red, bold = true })
          vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = bg0, bg = yellow, bold = true })
          vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = bg0, bg = purple, bold = true })

          vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = fg, bg = bg1 })
          vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = fg, bg = bg1 })
          vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = fg, bg = bg1 })
          vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = gray, bg = bg0 })
        end,
      })

      -- Trigger the autocmd if gruvbox is already loaded
      if vim.g.colors_name == "gruvbox" then
        vim.cmd("doautocmd ColorScheme gruvbox")
      end
    end,
  },
}

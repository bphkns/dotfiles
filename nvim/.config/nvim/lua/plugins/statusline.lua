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

      -- Apply Oasis Abyss colors to statusline
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "oasis-abyss",
        callback = function()
          -- Oasis Abyss palette
          local bg0 = "#000000" -- core background
          local bg1 = "#1A1A1A" -- surface
          local fg = "#F0EBE6" -- core foreground
          local gray = "#546D79" -- comment

          -- Oasis accent colors
          local green = "#53D390"
          local blue = "#519BFF"
          local orange = "#FFA247"
          local red = "#D06666"
          local yellow = "#F0E68C"
          local purple = "#C28EFF"

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

      -- Trigger the autocmd if oasis-abyss is already loaded
      if vim.g.colors_name == "oasis-abyss" then
        vim.cmd("doautocmd ColorScheme oasis-abyss")
      end
    end,
  },
}

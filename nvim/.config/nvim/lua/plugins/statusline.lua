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
    end,
  },
}

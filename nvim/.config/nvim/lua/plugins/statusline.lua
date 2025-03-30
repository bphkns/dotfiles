return {
  {
    "echasnovski/mini.statusline",
    version = "*",
    event = { "VeryLazy" },
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      statusline.section_location = function()
        return '%2l:%-2v'
      end

      statusline.section_filename = function(_)
        return ""
      end
    end,
  },

}

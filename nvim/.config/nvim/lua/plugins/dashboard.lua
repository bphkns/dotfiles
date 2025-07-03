return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
      "echasnovski/mini.icons",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Colorful ASCII art logo centered
      dashboard.section.header.val = {
        [[                                                     ]],
        [[              ███╗   ██╗██╗   ██╗██╗███╗   ███╗     ]],
        [[              ████╗  ██║██║   ██║██║████╗ ████║     ]],
        [[              ██╔██╗ ██║██║   ██║██║██╔████╔██║     ]],
        [[              ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║     ]],
        [[              ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║     ]],
        [[              ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝     ]],
        [[                                                     ]],
      }

      -- Custom buttons with cool icons
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", "  Restore Session", ":lua require('persistence').load() <CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy <CR>"),
        dashboard.button("q", "  Quit", ":qa <CR>"),
      }

      -- Footer with cool info
      local function footer()
        local total_plugins = require("lazy").stats().count
        local datetime = os.date("  %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

        return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
      end

      dashboard.section.footer.val = footer()

      -- Define rainbow highlight groups
      vim.api.nvim_set_hl(0, "AlphaHeader1", { fg = "#ff6b6b", bold = true }) -- Red
      vim.api.nvim_set_hl(0, "AlphaHeader2", { fg = "#4ecdc4", bold = true }) -- Teal
      vim.api.nvim_set_hl(0, "AlphaHeader3", { fg = "#45b7d1", bold = true }) -- Blue
      vim.api.nvim_set_hl(0, "AlphaHeader4", { fg = "#96ceb4", bold = true }) -- Green
      vim.api.nvim_set_hl(0, "AlphaHeader5", { fg = "#feca57", bold = true }) -- Yellow
      vim.api.nvim_set_hl(0, "AlphaHeader6", { fg = "#ff9ff3", bold = true }) -- Pink

      -- Apply rainbow colors to each line
      dashboard.section.header.opts.hl = {
        { { "AlphaHeader1", 0, -1 } },
        { { "AlphaHeader2", 0, -1 } },
        { { "AlphaHeader3", 0, -1 } },
        { { "AlphaHeader4", 0, -1 } },
        { { "AlphaHeader5", 0, -1 } },
        { { "AlphaHeader6", 0, -1 } },
        { { "AlphaHeader1", 0, -1 } },
        { { "AlphaHeader2", 0, -1 } },
      }

      dashboard.section.buttons.opts.hl = "Keyword"
      dashboard.section.footer.opts.hl = "Comment"

      -- Layout
      dashboard.opts.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.opts)
    end,
  },
}

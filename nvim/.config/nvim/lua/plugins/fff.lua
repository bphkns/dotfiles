return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    opts = {},
    lazy = false, -- the plugin lazy-initialises itself (background index warmup)
    keys = {
      {
        "<leader>ff",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files in project directory (fff)",
      },
      {
        "<leader>fg",
        function()
          require("fff").live_grep()
        end,
        desc = "Find by grepping in project directory (fff)",
      },
      {
        "<leader>fw",
        function()
          require("fff").live_grep({ query = vim.fn.expand("<cword>") })
        end,
        desc = "[F]ind current [W]ord (fff)",
      },
      {
        "<leader>fW",
        function()
          require("fff").live_grep({ query = vim.fn.expand("<cWORD>") })
        end,
        desc = "[F]ind current [W]ORD (fff)",
      },
      {
        "<leader>/",
        function()
          local fff = require("fff")
          local file = vim.fn.expand("%:.")
          -- unnamed or out-of-cwd buffers can't be targeted via a path constraint
          if file == "" or file:sub(1, 1) == "/" then
            fff.live_grep()
            return
          end
          fff.live_grep({ query = file .. " " })
        end,
        desc = "[/] Live grep the current file (fff)",
      },
    },
  },
}

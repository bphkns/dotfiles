return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    branch = "master",
    event = "BufReadPost",
    opts = { max_lines = 3 },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/trouble.nvim",
    branch = "main",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    },
    opts = {
      modes = {
        diagnostics = { auto_preview = false },
        symbols = { auto_preview = false },
      },
      preview = {
        type = "main",
        scratch = true,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = function()
      require("nvim-treesitter").install({
        "lua",
        "vim",
        "vimdoc",
        "angular",
        "tsx",
        "typescript",
        "html",
        "yaml",
        "json",
        "css",
        "scss",
        "sql",
        "jsx",
        "dockerfile",
        "prisma",
      })
    end,
    config = function()
      require("nvim-treesitter").setup({})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- Setup
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      -- Textobject select mappings (vi/va style)
      local select_maps = {
        -- Function
        { "af", "@function.outer" },
        { "if", "@function.inner" },
        -- Class
        { "ac", "@class.outer" },
        { "ic", "@class.inner" },
        -- Block
        { "ak", "@block.outer" },
        { "ik", "@block.inner" },
        -- Parameter/argument
        { "aa", "@parameter.outer" },
        { "ia", "@parameter.inner" },
        -- Conditional
        { "ao", "@conditional.outer" },
        { "io", "@conditional.inner" },
        -- Loop
        { "al", "@loop.outer" },
        { "il", "@loop.inner" },
        -- Assignment
        { "a=", "@assignment.outer" },
        { "i=", "@assignment.inner" },
        { "l=", "@assignment.lhs" },
        { "r=", "@assignment.rhs" },
      }

      for _, map in ipairs(select_maps) do
        vim.keymap.set({ "x", "o" }, map[1], function()
          select.select_textobject(map[2], "textobjects")
        end, { desc = "Select " .. map[2] })
      end

      -- Move to next/previous textobject
      local function map_move(key, query, fn)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          fn(query, "textobjects")
        end, { desc = key .. " " .. query })
      end

      map_move("]f", "@function.outer", move.goto_next_start)
      map_move("[f", "@function.outer", move.goto_previous_start)
      map_move("]c", "@class.outer", move.goto_next_start)
      map_move("[c", "@class.outer", move.goto_previous_start)
      map_move("]a", "@parameter.outer", move.goto_next_start)
      map_move("[a", "@parameter.outer", move.goto_previous_start)
      map_move("]o", "@conditional.outer", move.goto_next_start)
      map_move("[o", "@conditional.outer", move.goto_previous_start)
      map_move("]l", "@loop.outer", move.goto_next_start)
      map_move("[l", "@loop.outer", move.goto_previous_start)

      -- Swap parameters
      vim.keymap.set("n", "<leader>sn", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>sp", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap previous parameter" })

      -- Incremental selection
      local nodes = {}

      local function select_node(node)
        if not node then
          return
        end
        local sr, sc, er, ec = node:range()
        vim.cmd("normal! \27") -- exit to normal first
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
      end

      vim.keymap.set("n", "<C-Space>", function()
        nodes = {}
        local node = vim.treesitter.get_node()
        if node then
          table.insert(nodes, node)
          select_node(node)
        end
      end, { desc = "Start incremental selection" })

      vim.keymap.set("x", "<C-Space>", function()
        local current = nodes[#nodes]
        if not current then
          return
        end
        local parent = current:parent()
        while parent do
          if not vim.deep_equal({ current:range() }, { parent:range() }) then
            table.insert(nodes, parent)
            select_node(parent)
            return
          end
          parent = parent:parent()
        end
      end, { desc = "Expand selection" })

      vim.keymap.set("x", "<BS>", function()
        if #nodes > 1 then
          table.remove(nodes)
          select_node(nodes[#nodes])
        end
      end, { desc = "Shrink selection" })

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },
}

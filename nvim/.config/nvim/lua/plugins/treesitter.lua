return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
      },
    },
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local parsers = {
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
        "dockerfile",
        "prisma",
      }

      -- Setup nvim-treesitter (main branch - no config table)
      require("nvim-treesitter").setup()

      -- Install parsers (main branch API takes a table, not varargs)
      require("nvim-treesitter").install(parsers)

      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
        },
      })

      local function map(lhs, obj, desc)
        vim.keymap.set({ "x", "o" }, lhs, function()
          require("nvim-treesitter-textobjects.select").select_textobject(obj, "textobjects")
        end, { desc = desc })
      end
      -- assignment
      map("a=", "@assignment.outer", "Select outer assignment")
      map("i=", "@assignment.inner", "Select inner assignment")
      map("l=", "@assignment.lhs", "Select assignment LHS")
      map("r=", "@assignment.rhs", "Select assignment RHS")
      -- property
      map("a:", "@property.outer", "Select outer property")
      map("i:", "@property.inner", "Select inner property")
      map("l:", "@property.lhs", "Select property LHS")
      map("r:", "@property.rhs", "Select property RHS")

      map("ap", "@parameter.inner", "Select outer parameter")
      map("ip", "@parameter.inner", "Select inner parameter")

      map("af", "@function.outer", "Select outer function")
      map("if", "@function.inner", "Select inner function")

      map("ac", "@class.inner", "Select outer class")
      map("ic", "@class.inner", "Select inner class")

      map("ak", "@block.inner", "Select outer block")
      map("ik", "@block.inner", "Select inner block")

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous,
        { desc = "Repeat last move previous" })

      --
      --         swap = {
      --           enable = true,
      --           swap_next = {
      --             ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
      --             ["<leader>nm"] = "@function.outer",  -- swap function with next
      --             ["<leader>n:"] = "@property.outer",  -- swap object property with next
      --           },
      --           swap_previous = {
      --             ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
      --             ["<leader>pm"] = "@function.outer",  -- swap function with previous,
      --             ["<leader>p:"] = "@property.outer",  -- swap object property with prev
      --           },
      --         },
      --         move = {
      --           enable = true,
      --           set_jumps = true, -- whether to set jumps in the jumplist
      --           goto_next_start = {
      --             ["]f"] = { query = "@call.outer", desc = "Next function call start" },
      --             ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
      --             ["]c"] = { query = "@class.outer", desc = "Next class start" },
      --             ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
      --             ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
      --
      --             -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
      --             -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
      --             ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
      --             ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      --           },
      --           goto_next_end = {
      --             ["]F"] = { query = "@call.outer", desc = "Next function call end" },
      --             ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
      --             ["]C"] = { query = "@class.outer", desc = "Next class end" },
      --             ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
      --             ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
      --           },
      --           goto_previous_start = {
      --             ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
      --             ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
      --             ["[c"] = { query = "@class.outer", desc = "Prev class start" },
      --             ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
      --             ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
      --           },
      --           goto_previous_end = {
      --             ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
      --             ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
      --             ["[C"] = { query = "@class.outer", desc = "Prev class end" },
      --             ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
      --             ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
      --           },
      --         },
      --       },
      --     })
      --
      --     local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      --
      --     -- vim way: ; goes to the direction you were moving.
      --     vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      --     vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
      --
      --     -- Updated to use non-deprecated functions with expr = true
      --     vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      --     vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      --     vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      --     vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
      -- Register the todotxt parser to be used for text filetypes
      vim.treesitter.language.register("todotxt", "text")

      -- Enable treesitter highlighting for all buffers
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
  {
    "bezhermoso/tree-sitter-ghostty",
    build = "make nvim_install",
  }
}

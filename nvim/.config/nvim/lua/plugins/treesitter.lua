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
      require("nvim-treesitter").setup({})
      require("nvim-treesitter").install(
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
        "prisma"
      )

      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
        },
      })

      local function map(lhs, obj)
        vim.keymap.set({ "x", "o" }, lhs, function()
          require("nvim-treesitter-textobjects.select").select_textobject(obj, "textobjects")
        end)
      end
      -- assignment
      map("a=", "@assignment.outer")
      map("i=", "@assignment.inner")
      map("l=", "@assignment.lhs")
      map("r=", "@assignment.rhs")
      -- property
      map("a:", "@property.outer")
      map("i:", "@property.inner")
      map("l:", "@property.lhs")
      map("r:", "@property.rhs")

      map("ap", "@parameter.inner")
      map("ip", "@parameter.inner")

      map("af", "@function.outer")
      map("if", "@function.inner")

      map("ac", "@class.inner")
      map("ic", "@class.inner")

      map("ak", "@block.inner")
      map("ik", "@block.inner")

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

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
}

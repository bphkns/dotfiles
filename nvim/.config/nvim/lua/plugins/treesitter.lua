return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "angular", "tsx", "typescript",
        "html", "yaml", "json", "css", "scss", "sql", "dockerfile", "prisma",
      })
    end,
  },
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    config = function()
      local ai = require("mini.ai")
      local ts = ai.gen_spec.treesitter

      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          f = ts({ a = "@function.outer", i = "@function.inner" }),
          c = ts({ a = "@class.outer", i = "@class.inner" }),
          k = ts({ a = "@block.outer", i = "@block.inner" }),
          a = ts({ a = "@parameter.outer", i = "@parameter.inner" }),
          o = ts({ a = { "@conditional.outer", "@loop.outer" }, i = { "@conditional.inner", "@loop.inner" } }),
          ["="] = ts({ a = "@assignment.outer", i = "@assignment.inner" }),
          [":"] = ts({ a = "@property.outer", i = "@property.inner" }),
        },
      })

      -- Incremental selection
      local nodes = {}

      local function select_node(node)
        if not node then return end
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
        if not current then return end
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
    end,
  },
  {
    "bezhermoso/tree-sitter-ghostty",
    build = "make nvim_install",
  },
}

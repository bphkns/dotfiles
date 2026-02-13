return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  opts = {
    window = {
      position = "right",
      mappings = {
        ["Y"] = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local relative = vim.fn.fnamemodify(filepath, ":.")
          local stem = vim.fn.fnamemodify(filename, ":r")

          local options = {
            "1. File name: " .. filename,
            "2. Relative path: " .. relative,
            "3. Full path: " .. filepath,
            "4. File name (no ext): " .. stem,
          }

          vim.ui.select(options, { prompt = "Copy to clipboard:" }, function(choice)
            if not choice then return end
            local values = { filename, relative, filepath, stem }
            local idx = tonumber(choice:sub(1, 1))
            local value = values[idx]
            vim.fn.setreg("+", value)
            vim.notify("Copied: " .. value)
          end)
        end,
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
    vim.keymap.set("n", "<C-e>", function()
      require("neo-tree.command").execute({
        toggle = true,
        source = "filesystem",
        dir = vim.fn.getcwd(),
        position = "right",
        reveal_file = vim.fn.expand("%:p"),
        reveal_force_cwd = true,
      })
    end, { desc = "Toggle Explorer" })
  end,
}

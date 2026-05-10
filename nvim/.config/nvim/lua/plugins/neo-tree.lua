return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "echasnovski/mini.icons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "<C-e>",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          source = "filesystem",
          dir = vim.fn.getcwd(),
          position = "right",
          reveal_file = vim.fn.expand("%:p"),
          reveal_force_cwd = true,
        })
      end,
      desc = "Toggle Explorer",
    },
  },
  opts = {
    default_component_configs = {
      icon = {
        provider = function(icon, node)
          local text, hl
          local mini_icons = require("mini.icons")
          if node.type == "file" then
            text, hl = mini_icons.get("file", node.name)
          elseif node.type == "directory" then
            text, hl = mini_icons.get("directory", node.name)
            if node:is_expanded() then
              text = nil
            end
          end
          if text then
            icon.text = text
          end
          if hl then
            icon.highlight = hl
          end
        end,
      },
    },
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
            if not choice then
              return
            end
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
}

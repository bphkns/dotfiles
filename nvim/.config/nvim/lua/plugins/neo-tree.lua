return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false, -- This makes filtered items visible by default
          hide_dotfiles = false,
          hide_gitignored = false, -- Don't hide gitignored files by default
          hide_hidden = false,
          hide_by_name = {
            ".git",
            "node_modules",
          },
          never_show = { -- remains hidden even if visible is toggled to true
            ".DS_Store",
            "thumbs.db",
          },
        },
        follow_current_file = true,
        group_empty_dirs = false,
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
        window = {
          mappings = {
            ["/"] = "fuzzy_finder",
            ["<leader>P"] = { "toggle_image_preview", config = { use_float = true } },
            ["Y"] = function(state)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local filename = node.name
              local modify = vim.fn.fnamemodify
              local results = {
                filepath,
                modify(filepath, ":."),
                modify(filepath, ":~"),
                filename,
                modify(filename, ":r"),
                modify(filename, ":e"),
              }
              local messages = {
                "Choose to copy to clipboard:",
                "1. Absolute path: " .. results[1],
                "2. Path relative to CWD: " .. results[2],
                "3. Path relative to HOME: " .. results[3],
                "4. Filename: " .. results[4],
                "5. Filename without extension: " .. results[5],
                "6. Extension of the filename: " .. results[6],
              }
              vim.api.nvim_echo({ { table.concat(messages, "\n"), "Normal" } }, true, {})
              local i = vim.fn.getchar()
              if i >= 49 and i <= 54 then
                local result = results[i - 48]
                print(result)
                vim.fn.setreg("*", result)
              else
                print("Invalid choice: " .. string.char(i))
              end
            end,
          },
        },
        commands = {
          toggle_image_preview = function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              require("image_preview").PreviewImage(node.path)
            end
          end,
        },
        fuzzy_finder_mappings = {
          -- define keymaps for filter popup window in fuzzy_finder_mode
          ["<C-j>"] = "move_cursor_down",
          ["<C-k>"] = "move_cursor_up",
        },
      },
      window = {
        position = "right",
      },
    },
    keys = {
      { "<leader>E", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>e", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
  },
}

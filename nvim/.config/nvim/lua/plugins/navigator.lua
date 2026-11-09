return {
  {
    -- vim-tmux-navigator stays installed so its TmuxNavigate* commands remain
    -- available as the tmux fallback. vim-herdr-navigation owns <C-h/j/k/l>:
    -- it moves between Neovim splits, hands off to herdr panes at a split edge,
    -- and falls back to tmux (when $TMUX is set) or plain wincmd otherwise.
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    init = function()
      -- Disable vim-tmux-navigator's own <C-h/j/k/l> maps; the herdr plugin
      -- below is the single source of truth for those keys.
      vim.g.tmux_navigator_no_mappings = 1
    end,
    dependencies = {
      {
        "paulbkim-dev/vim-herdr-navigation",
        config = function(plugin)
          dofile(plugin.dir .. "/editor/nvim.lua")
          -- herdr-app (no $HERDR_PANE_ID; core terminals set $HC_TERMINAL_ID): at a
          -- split edge, cross into the neighbouring herdr-app pane.
          if (vim.env.HERDR_PANE_ID or "") ~= "" or (vim.env.HC_TERMINAL_ID or "") == "" then
            return
          end
          local dirs = { h = "left", j = "down", k = "up", l = "right" }
          for key, dir in pairs(dirs) do
            vim.keymap.set("n", "<C-" .. key .. ">", function()
              local prev = vim.api.nvim_get_current_win()
              vim.cmd("wincmd " .. key)
              if vim.api.nvim_get_current_win() ~= prev then
                return
              end
              vim.system({ "herdr-app", "do", "pane.go", "--direction", dir })
            end, { silent = true, noremap = true, desc = "Navigate " .. dir .. " (vim/herdr-app)" })
          end
        end,
      },
    },
    keys = {
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate to previous (tmux/vim)" },
    },
  },
}

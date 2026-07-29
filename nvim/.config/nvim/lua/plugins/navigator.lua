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
        end,
      },
    },
    keys = {
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate to previous (tmux/vim)" },
    },
  },
}

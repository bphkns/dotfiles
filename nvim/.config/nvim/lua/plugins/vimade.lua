return {
  "TaDaa/vimade",
  event = "VeryLazy",
  opts = {
    recipe = { "default", { animate = false } },
    ncmode = "windows",
    fadelevel = 0.4,
    enablefocusfading = true,
    link = {
      neo_tree_with_editor = function(win, active)
        if not active then
          return false
        end

        return active.buf_opts.filetype == "neo-tree" or win.buf_opts.filetype == "neo-tree"
      end,
    },
  },
}

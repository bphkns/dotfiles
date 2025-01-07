return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  opts = function(_, opts)
    local fzf = require("fzf-lua")
    local config = fzf.config

    config.defaults.actions.files["ctrl-r"] = function(_, ctx)
      local o = vim.deepcopy(ctx.__call_opts)
      o.root = not o.root -- Toggle root directory
      o.cwd = nil         -- Reset cwd
      o.buf = ctx.__CTX.bufnr -- Set the buffer number to the context

      -- Open the picker with the new options (without LazyVim)
      fzf.files(o) -- Open the fzf file picker, using the modified options
    end

    config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
    config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")
  end,
  keys = {
    {
      "<leader><leader>",
      function()
        require("fzf-lua").files()
      end
      ,
      desc = "Find Files (cwd)"
    },
    {
      "<leader>r",
      function()
        require("fzf-lua").oldfiles()
      end
      ,
      desc = "Find Recent Files"
    },
    {
      "<leader>f",
      function()
        require("fzf-lua").live_grep()
      end
      ,
      desc = "Find Text"
    },
  }
}

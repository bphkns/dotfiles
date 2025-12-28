
return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      winopts    = {
        height     = 0.85,
        width      = 0.80,
        row        = 0.35,
        col        = 0.50,
        border     = "rounded",
        backdrop   = 60,
        title_pos  = "center",
        preview    = {
          vertical   = "down:45%",
          horizontal = "right:50%",
          layout     = "vertical",
          scrollbar  = "border",
          scrolloff  = "-2",
          title_pos  = "center",
        },
      },
      fzf_colors = true,
      files      = {
        cmd =
        "fd --type f --hidden --follow --no-ignore-vcs --exclude .git --exclude node_modules --exclude .nx --exclude .angular --exclude .cache --exclude dist",
      },
      grep       = {
        cwd_prompt = true,
        rg_opts =
        "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!.git/' -g '!node_modules/' -g '!.nx/' -g '!.angular/' --fixed-strings",
      },
      keymap     = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        }
      },
      fzf_opts   = {
        ['--layout']  = 'reverse',
        ['--prompt']  = ' ',
        ['--pointer'] = ' ',
        ['--marker']  = '✓ ',
      }
    },
    event = "VeryLazy",
    keys = {
      {
        "<leader>ff",
        function()
          require("fzf-lua").files()
        end,
        desc = "Find Files in project directory",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep({ cwd = vim.fn.getcwd() })
        end,
        desc = "Find by grepping in project directory",
      },
      {
        "<leader>fc",
        function()
          require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find in neovim configuration",
      },
      {
        "<leader>fh",
        function()
          require("fzf-lua").helptags()
        end,
        desc = "[F]ind [H]elp",
      },
      {
        "<leader>fk",
        function()
          require("fzf-lua").keymaps()
        end,
        desc = "[F]ind [K]eymaps",
      },
      {
        "<leader>fb",
        function()
          require("fzf-lua").builtin()
        end,
        desc = "[F]ind [B]uiltin FZF",
      },
      {
        "<leader>fw",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "[F]ind current [W]ord",
      },
      {
        "<leader>fW",
        function()
          require("fzf-lua").grep_cWORD()
        end,
        desc = "[F]ind current [W]ORD",
      },
      {
        "<leader>fd",
        function()
          require("fzf-lua").diagnostics_document()
        end,
        desc = "[F]ind [D]iagnostics",
      },
      {
        "<leader>fr",
        function()
          require("fzf-lua").resume()
        end,
        desc = "[F]ind [R]esume",
      },
      {
        "<leader>fo",
        function()
          require("fzf-lua").oldfiles({ cwd_only = true })
        end,
        desc = "[F]ind [O]ld Files (cwd only)",
      },
      {
        "<leader><leader>",
        function()
          require("fzf-lua").buffers()
        end,
        desc = "[,] Find existing buffers",
      },
      {
        "<leader>/",
        function()
          require("fzf-lua").lgrep_curbuf()
        end,
        desc = "[/] Live grep the current buffer",
      },

    },
    config = function(_, opts)
      require("fzf-lua").setup(opts)
    end,
  },
}

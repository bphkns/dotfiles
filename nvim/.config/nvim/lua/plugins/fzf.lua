return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      winopts = {
        height = 0.85,
        width = 0.80,
      },
      files = {
        cmd = "fd --type f --hidden --follow --exclude .git node_modules --no-ignore-vcs ",
      },
      grep = {
        cwd_prompt = true, -- Show the current working directory
        rg_opts =
        "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!.git/' -g '!node_modules/' -g '!.nx/' -g '!.angular/'",
      },
    },
    events = { "VeryLazy" },
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
          require("fzf-lua").oldfiles()
        end,
        desc = "[F]ind [O]ld Files",
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
      -- LSP-related keybindings (without the unsupported "has" field)
      {
        "gd",
        "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>",
        desc = "Goto Definition",
      },
      {
        "gr",
        "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>",
        desc = "References",
        nowait = true,
      },
      {
        "gI",
        "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>",
        desc = "Goto Implementation",
      },
      {
        "gy",
        "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>",
        desc = "Goto T[y]pe Definition",
      },
      {
        "<leader>ca",
        ":lua require('fzf-lua').lsp_code_actions({ async = false })<cr>",
        desc = "Code Actions",
        nowait = true,
      },
    },
    config = function(_, opts)
      require("fzf-lua").setup(opts)
    end,
  },
}

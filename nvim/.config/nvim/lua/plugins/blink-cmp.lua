return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "moyiz/blink-emoji.nvim",
      "onsails/lspkind.nvim",
    },
    version = "*",
    opts = {
      keymap = {
        preset = "default",
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
      },
      appearance = {
        kind_icons = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "",
          Copilot = "",
          Codeium = "",
          TabNine = "",
          Supermaven = "",
        },
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer", "emoji" },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
            opts = { insert = true },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = false },
      },
      fuzzy = { implementation = "rust" },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
}

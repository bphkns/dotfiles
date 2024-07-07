return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      ensure_installed = {
        "nxls",
        "angularls",
      },
      servers = {
        angularls = {
          root_dir = require("lspconfig").util.root_pattern("angular.json", "project.json"),
          filetypes = { "angular", "html", "typescript", "typescriptreact" },
        },
        tsserver = {
          settings = {
            completions = {
              completeFunctionCalls = false,
            },
            signatureHelp = {
              enabled = false,
            },
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            if not entry then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              cmp.confirm()
            end
          else
            fallback()
          end
        end, { "i", "s", "c" }),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { eslint = {} },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
}

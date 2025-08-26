return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
      "yioneko/nvim-vtsls"
    },
    opts = {
      diagnostics = {
        virtual_text = { prefix = "●", source = "if_many" },
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      },
      servers = {
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_dir = function()
            local util = require("lspconfig.util")
            return util.root_pattern("nx.json", "angular.json", "package.json", ".git")(vim.fn.getcwd())
          end,
          single_file_support = false,
          settings = {
            complete_function_calls = false,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              preferences = { importModuleSpecifier = "project-relative" },
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = false,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        angularls = {
          filetypes = {
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "htmlangular"
          },
          root_dir = function()
            local util = require("lspconfig.util")
            return util.root_pattern("angular.json", "nx.json")(vim.fn.getcwd())
          end,
          single_file_support = false,
        },
        eslint = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "htmlangular" },
          settings = { format = { enable = false }, run = "onSave" },
        },
        html = {
          filetypes = { "html", "mjml" },
        },
        cssls = {
          filetypes = { "css", "scss", "less" },
        },
        emmet_ls = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        jsonls = {
          settings = {
            json = {
              schemas = function()
                return require("schemastore").json.schemas()
              end,
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
      },
    },
    keys = {
      { "<space>e",   vim.diagnostic.open_float,  desc = "Open diagnostic float" },
      { "<leader>rn", vim.lsp.buf.rename,         desc = "Rename" },
      { "<leader>sh", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "K",          vim.lsp.buf.hover,          desc = "Hover" },
      {
        "<leader>cr",
        function() require('vtsls').commands.remove_unused_imports(0) end,
        desc = "Remove unused imports"
      },
      {
        "<leader>co",
        function() require('vtsls').commands.organize_imports(0) end,
        desc = "Organize imports"
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        automatic_installation = true,
        automatic_enable = false,
      })
      vim.diagnostic.config(opts.diagnostics)
      for server, config in pairs(opts.servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
}

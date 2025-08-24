return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
      "yioneko/nvim-vtsls",
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
          filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
          root_dir = function()
            local util = require("lspconfig.util")
            return util.root_pattern("nx.json", "angular.json", "package.json", ".git")(vim.fn.getcwd())
          end,
          single_file_support = false,
          settings = {
            typescript = {
              preferences = { importModuleSpecifier = "project-relative" },
              suggest = { autoImports = true },
            },
            javascript = {
              preferences = { importModuleSpecifier = "project-relative" },
              suggest = { autoImports = true },
            },
          },
        },
        angularls = {
          filetypes = { "typescript", "html", "typescriptreact", "htmlangular" },
          root_dir = function()
            local util = require("lspconfig.util")
            return util.root_pattern("angular.json", "nx.json")(vim.fn.getcwd())
          end,
          single_file_support = false,
        },
        eslint = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
      { "<space>e", vim.diagnostic.open_float, desc = "Open diagnostic float" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
      { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>sh", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      
      require("mason").setup()
      
      vim.diagnostic.config(opts.diagnostics)
      
      local on_attach = function(client, bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        
        -- TypeScript/JavaScript specific - auto organize imports on save
        if client.name == "vtsls" then
          if client.server_capabilities.codeActionProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
            })
          end
        end
        
        -- Handle conflicts between vtsls and angularls
        -- LazyVim style: disable formatting for vtsls when angularls is active
        if client.name == "vtsls" then
          local angular_client = vim.lsp.get_clients({ bufnr = bufnr, name = "angularls" })[1]
          if angular_client then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end
        
        -- Handle conflicts for angularls when vtsls is active
        if client.name == "angularls" then
          local vtsls_client = vim.lsp.get_clients({ bufnr = bufnr, name = "vtsls" })[1]
          if vtsls_client then
            -- Disable Angular's TypeScript features to prevent conflicts
            client.server_capabilities.renameProvider = false
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.implementationProvider = false
          end
        end
        
        -- Handle eslint conflicts
        if client.name == "eslint" then
          -- Disable eslint formatting if prettier or other formatters are active
          local prettier_client = vim.lsp.get_clients({ bufnr = bufnr, name = "prettier" })[1]
          if prettier_client then
            client.server_capabilities.documentFormattingProvider = false
          end
        end
      end
      
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink_cmp = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink_cmp.get_lsp_capabilities(capabilities)
      end
      
      -- Setup servers with mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server_opts = opts.servers[server_name] or {}
            server_opts.on_attach = on_attach
            server_opts.capabilities = capabilities
            
            lspconfig[server_name].setup(server_opts)
          end,
        },
      })
      
      -- Global keymaps for TypeScript files (LazyVim style)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "vtsls" then
            local bufnr = args.buf
            
            vim.keymap.set("n", "<leader>co", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports" },
                  diagnostics = {},
                },
              })
            end, { buffer = bufnr, desc = "Organize imports" })
            
            vim.keymap.set("n", "<leader>cr", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end, { buffer = bufnr, desc = "Remove unused imports" })
            
            vim.keymap.set("n", "<leader>cu", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused" },
                  diagnostics = {},
                },
              })
            end, { buffer = bufnr, desc = "Remove unused" })
            
            vim.keymap.set("n", "<leader>cM", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.addMissingImports.ts" },
                  diagnostics = {},
                },
              })
            end, { buffer = bufnr, desc = "Add missing imports" })
          end
        end,
      })
    end,
  },
}
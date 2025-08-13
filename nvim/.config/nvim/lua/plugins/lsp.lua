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
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      require("mason").setup()

      vim.diagnostic.config({
        virtual_text = { prefix = "●", source = "if_many" },
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        
        -- TypeScript/JavaScript specific keymaps
        if client.name == "vtsls" then
          vim.keymap.set("n", "<leader>co", function()
            vim.lsp.buf.execute_command({
              command = "_typescript.organizeImports",
              arguments = { vim.api.nvim_buf_get_name(0) }
            })
          end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
          
          vim.keymap.set("n", "<leader>cr", function()
            vim.lsp.buf.execute_command({
              command = "_typescript.removeUnused",
              arguments = { vim.api.nvim_buf_get_name(0) }
            })
          end, vim.tbl_extend("force", opts, { desc = "Remove unused imports" }))
        end

        -- Auto organize imports on save for TypeScript/JavaScript files
        if client.name == "vtsls" and client.server_capabilities.codeActionProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
              }
              client.request("workspace/executeCommand", params, nil, bufnr)
            end,
          })
        end

        if client.name == "vtsls" and vim.lsp.get_clients({ bufnr = bufnr, name = "angularls" })[1] then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink_cmp = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink_cmp.get_lsp_capabilities(capabilities)
      end

      local root_dir = function(fname)
        return util.root_pattern("nx.json", "angular.json", "package.json", ".git")(fname)
      end

      local servers = {
        vtsls = {
          filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
          root_dir = root_dir,
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
          root_dir = function(fname) return util.root_pattern("angular.json", "nx.json")(fname) end,
          single_file_support = false,
        },
        eslint = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_dir = root_dir,
          settings = { format = { enable = false }, run = "onSave" },
        },
        html = {
          filetypes = { "html", "mjml" },
          root_dir = root_dir,
        },
        cssls = {
          filetypes = { "css", "scss", "less" },
          root_dir = root_dir,
        },
        emmet_ls = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_dir = root_dir,
        },
        jsonls = {
          root_dir = root_dir,
          settings = { json = { schemas = require("schemastore").json.schemas() } },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      }

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = {
          function(server_name)
            local config = vim.tbl_deep_extend("force", {
              on_attach = on_attach,
              capabilities = capabilities,
            }, servers[server_name] or {})
            lspconfig[server_name].setup(config)
          end,
        },
      })
    end,
  },
}

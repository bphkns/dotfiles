return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      ensure_installed = {
        "angularls",
        "emmet_ls",
        "jsonls",
        "vtsls",
        "lua_ls",
      },
      servers = {
        vtsls = {},
        angularls = {},
        emmet_ls = {},
        jsonls = {},
        lua_ls = {},
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local util = require("lspconfig.util")

      -- Get Angular LS path function
      local function get_angular_ls_path()
        local workspace_root = util.root_pattern("nx.json")(vim.fn.getcwd())
        if workspace_root then
          return workspace_root .. "/node_modules/@angular/language-server"
        end
        return nil
      end

      -- Basic diagnostic configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Diagnostic keymaps
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

      local on_attach = function(client, bufnr)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = bufnr })
        vim.keymap.set("n", "<space>sh", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = bufnr })
      end

      -- Mason setup
      mason.setup()
      mason_lspconfig.setup({ ensure_installed = opts.ensure_installed })

      -- Configure Angular if found
      local angular_ls_path = get_angular_ls_path()
      if angular_ls_path then
        opts.servers.angularls = opts.servers.angularls or {}
        opts.servers.angularls.root_dir = function(fname)
          return util.root_pattern("angular.json", "nx.json")(fname)
        end
        opts.servers.angularls.filetypes =
          { "angular", "html", "typescript", "typescriptreact", "htmlangular", "typescript.tsx" }
      end

      -- TypeScript setup
      lspconfig.vtsls.setup({
        on_attach = on_attach,
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
            preferences = {
              importModuleSpecifier = "non-relative",
              autoImportFileExcludePatterns = { "**/node_modules/**" },
            },
            suggest = {
              completeFunctionCalls = true,
              includeAutomaticOptionalChainCompletions = true,
            },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
            },
            preferences = {
              importModuleSpecifier = "non-relative",
              autoImportFileExcludePatterns = { "**/node_modules/**" },
            },
          },
        },
      })

      -- Lua setup
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
              checkThirdParty = false,
            },
          },
        },
      })

      -- Setup other servers with blink capabilities
      for server, config in pairs(opts.servers) do
        if server ~= "vtsls" and server ~= "lua_ls" then
          config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
          config.on_attach = on_attach
          lspconfig[server].setup(config)
        end
      end
    end,
  },
}

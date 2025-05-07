return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "yioneko/nvim-vtsls", -- Ensure nvim-vtsls is installed
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

      -- Function to get Angular LS path
      local function get_angular_ls_path()
        local workspace_root = util.root_pattern("nx.json")(vim.fn.getcwd())
        if workspace_root then
          return workspace_root .. "/node_modules/@angular/language-server"
        end
        return nil
      end

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

      -- Common on_attach for all servers
      local on_attach = function(client, bufnr)
        local bufopts = { buffer = bufnr }
        vim.keymap.set(
          "n",
          "<leader>rn",
          vim.lsp.buf.rename,
          vim.tbl_extend("force", bufopts, { desc = "Rename Symbol" })
        )
        vim.keymap.set(
          "n",
          "<leader>sh",
          vim.lsp.buf.signature_help,
          vim.tbl_extend("force", bufopts, { desc = "Signature Help" })
        )
        -- Updated keymap for organize imports using nvim-vtsls
        vim.keymap.set("n", "<leader>cu", function()
          require("vtsls").commands.organize_imports(vim.api.nvim_get_current_buf())
        end, vim.tbl_extend("force", bufopts, { desc = "Organize Imports" }))
      end

      -- Setup Mason and ensure servers are installed
      mason.setup()
      mason_lspconfig.setup({ ensure_installed = opts.ensure_installed })

      -- Configure Angular LS if the workspace is found
      local angular_ls_path = get_angular_ls_path()
      if angular_ls_path then
        opts.servers.angularls = opts.servers.angularls or {}
        opts.servers.angularls.root_dir = function(fname)
          return util.root_pattern("angular.json", "nx.json")(fname)
        end
        opts.servers.angularls.filetypes =
        { "angular", "html", "typescript", "typescriptreact", "htmlangular", "typescript.tsx" }
        opts.servers.angularls.cmd = {
          "node",
          angular_ls_path .. "/bin/ngserver",
          "--stdio",
          "--tsProbeLocations",
          angular_ls_path .. "/node_modules",
          "--ngProbeLocations",
          angular_ls_path .. "/node_modules",
        }
      end

      -- TypeScript setup for vtsls with specific settings
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
              importModuleSpecifier = "project-relative",
            },
            suggest = {
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
              importModuleSpecifier = "relative",
            },
          },
        },
      })

      -- Lua setup; merging extra opts if any
      lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", {
        on_attach = on_attach,
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
      }, opts.servers.lua_ls or {}))

      -- Setup remaining servers (angularls, emmet_ls, jsonls, etc.) with blink capabilities
      for server, config in pairs(opts.servers) do
        if server ~= "vtsls" and server ~= "lua_ls" then
          config = vim.tbl_deep_extend("force", config, {
            on_attach = on_attach,
            capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities),
          })
          lspconfig[server].setup(config)
        end
      end
    end,
  },
}

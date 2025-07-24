return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "yioneko/nvim-vtsls",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      -- Setup Mason
      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = {
          "angularls",
          "vtsls",
          "eslint",
          "lua_ls",
          "emmet_ls",
          "jsonls",
        },
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = { prefix = "●", source = "if_many" },
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Global keymaps
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

      -- Common on_attach function for all LSP servers
      local on_attach = function(client, bufnr)
        local bufopts = { buffer = bufnr }

        -- Common LSP keymaps
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
        vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })

        -- TypeScript/JavaScript specific keymaps
        if client.name == "vtsls" or client.name == "angularls" then
          local ok, vtsls = pcall(require, "vtsls")
          if ok then
            vim.keymap.set("n", "<leader>co", function()
              vtsls.commands.organize_imports(bufnr)
            end, { buffer = bufnr, desc = "Organize Imports" })

            vim.keymap.set("n", "<leader>cu", function()
              vtsls.commands.remove_unused_imports(bufnr)
            end, { buffer = bufnr, desc = "Remove Unused Imports" })

            vim.keymap.set("n", "<leader>cr", function()
              vtsls.commands.remove_unused(bufnr)
            end, { buffer = bufnr, desc = "Remove Unused" })

            vim.keymap.set("n", "<leader>cm", function()
              vtsls.commands.add_missing_imports(bufnr)
            end, { buffer = bufnr, desc = "Add Missing Imports" })

            vim.keymap.set("n", "<leader>cf", function()
              vtsls.commands.fix_all(bufnr)
            end, { buffer = bufnr, desc = "Fix All" })

            vim.keymap.set("n", "<leader>cA", function()
              vtsls.commands.source_actions(bufnr)
            end, { buffer = bufnr, desc = "Source Actions" })

            vim.keymap.set("n", "<leader>cR", function()
              vtsls.commands.rename_file(bufnr)
            end, { buffer = bufnr, desc = "Rename File" })
          end
        end

        -- Disable ESLint formatting
        if client.name == "eslint" then
          client.server_capabilities.documentFormattingProvider = false
        end
      end

      -- Get LSP capabilities
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Server configurations
      local servers = {
        -- TypeScript/JavaScript
        vtsls = {
          settings = {
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
              diagnostics = { ignoredCodes = { 6133, 6196 } },
            },
          },
        },

        -- Angular
        angularls = {
          filetypes = { "typescript", "typescriptreact", "html" },
          root_dir = lspconfig.util.root_pattern("angular.json", "nx.json"),
        },

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true },
                checkThirdParty = false,
              },
            },
          },
        },

        -- ESLint
        eslint = {
          settings = {
            format = { enable = false },
            workingDirectories = { mode = "auto" },
            run = "onSave",
          },
        },

        -- Others
        emmet_ls = {},
        jsonls = {},
      }

      -- Special handling for Angular in nx workspaces
      local util = require("lspconfig.util")
      local function get_angular_ls_cmd()
        local workspace_root = util.root_pattern("nx.json")(vim.fn.getcwd())
        if workspace_root then
          local angular_ls_path = workspace_root .. "/node_modules/@angular/language-server"
          if vim.fn.isdirectory(angular_ls_path) == 1 then
            return {
              "node",
              "--max-old-space-size=8192",
              angular_ls_path .. "/bin/ngserver",
              "--stdio",
              "--tsProbeLocations",
              angular_ls_path .. "/node_modules",
              "--ngProbeLocations",
              angular_ls_path .. "/node_modules",
            }
          end
        end
        return nil
      end

      -- Setup all servers
      for server, config in pairs(servers) do
        config.on_attach = on_attach
        config.capabilities = capabilities
        
        -- Use custom cmd for Angular in nx workspaces
        if server == "angularls" then
          local custom_cmd = get_angular_ls_cmd()
          if custom_cmd then
            config.cmd = custom_cmd
          end
        end
        
        lspconfig[server].setup(config)
      end
    end,
  },
}


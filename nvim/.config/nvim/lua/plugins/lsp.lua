return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "yioneko/nvim-vtsls",
      "b0o/schemastore.nvim",
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
          "html",
          "cssls",
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
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

      -- Common on_attach function
      local on_attach = function(client, bufnr)
        local keymap_opts = { buffer = bufnr, silent = true }
        
        -- Common LSP keymaps
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
        vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Find References" })
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to Implementation" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })

        -- TypeScript/JavaScript specific keymaps for vtsls only
        if client.name == "vtsls" then
          local ok, vtsls = pcall(require, "vtsls")
          if ok then
            vim.keymap.set("n", "<leader>co", function()
              vtsls.commands.organize_imports(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Organize Imports" }))

            vim.keymap.set("n", "<leader>cu", function()
              vtsls.commands.remove_unused_imports(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Remove Unused Imports" }))

            vim.keymap.set("n", "<leader>cr", function()
              vtsls.commands.remove_unused(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Remove Unused" }))

            vim.keymap.set("n", "<leader>cA", function()
              vtsls.commands.source_actions(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Source Actions" }))

            vim.keymap.set("n", "<leader>cm", function()
              vtsls.commands.add_missing_imports(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Add Missing Imports" }))

            vim.keymap.set("n", "<leader>cf", function()
              vtsls.commands.fix_all(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Fix All" }))

            vim.keymap.set("n", "<leader>cR", function()
              vtsls.commands.rename_file(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Rename File" }))
          end
        end

        -- Disable formatting for ESLint
        if client.name == "eslint" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        -- For Angular Language Server, disable TypeScript features when vtsls is active
        if client.name == "angularls" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          
          -- Check if we're in a TypeScript file and vtsls is attached
          local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
          local has_vtsls = vim.tbl_contains(vim.tbl_map(function(c) return c.name end, clients), "vtsls")
          
          if has_vtsls and (vim.bo[bufnr].filetype == "typescript" or vim.bo[bufnr].filetype == "typescriptreact") then
            -- Disable overlapping features to prevent conflicts
            client.server_capabilities.renameProvider = false
            client.server_capabilities.codeActionProvider = false
          end
        end
      end

      -- Get LSP capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink_cmp = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink_cmp.get_lsp_capabilities(capabilities)
      end
      
      -- Enable folding capabilities for nvim-ufo
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      -- Common inlay hints settings
      local inlay_hints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }

      -- Server configurations
      local servers = {
        vtsls = {
          filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
          root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
          single_file_support = true,
          init_options = {
            preferences = {
              disableSuggestions = false,
            },
          },
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
              preferences = {
                importModuleSpecifier = "project-relative",
                includePackageJsonAutoImports = "auto",
              },
              suggest = {
                autoImports = true,
              },
              inlayHints = inlay_hints,
            },
            javascript = {
              preferences = {
                importModuleSpecifier = "project-relative",
                includePackageJsonAutoImports = "auto",
              },
              suggest = {
                autoImports = true,
              },
              inlayHints = inlay_hints,
            },
          },
        },

        angularls = {
          filetypes = { "html", "typescript", "typescriptreact" },
          root_dir = lspconfig.util.root_pattern("angular.json", "nx.json"),
          single_file_support = false,
        },

        html = {
          filetypes = { "html", "mjml" },
          settings = {
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                unformatted = "wbr",
                indentInnerHtml = true
              },
              validate = true,
              suggest = {
                html5 = true
              }
            }
          },
          init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
              css = true,
              javascript = true
            },
            provideFormatter = true
          },
        },

        cssls = {
          filetypes = { "css", "scss", "less" },
          settings = {
            css = {
              validate = true,
              lint = {
                compatibleVendorPrefixes = "ignore",
                vendorPrefix = "warning",
                duplicateProperties = "warning"
              }
            }
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

        eslint = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
          settings = {
            format = { enable = false },
            workingDirectories = { mode = "auto" },
            run = "onSave",
            validate = "on",
            packageManager = "npm",
          },
          root_dir = lspconfig.util.root_pattern(
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "package.json"
          ),
        },

        emmet_ls = {
          filetypes = {
            "html", "css", "scss", "sass", "less",
            "javascript", "javascriptreact", "typescript", "typescriptreact"
          },
        },

        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
      }

      -- Check for Angular Language Server in Nx workspaces
      local function get_angular_ls_cmd()
        local util = require("lspconfig.util")
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

        -- Use custom cmd for Angular in Nx workspaces
        if server == "angularls" then
          local custom_cmd = get_angular_ls_cmd()
          if custom_cmd then
            config.cmd = custom_cmd
          end
        end

        lspconfig[server].setup(config)
      end

      -- MJML filetype detection
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.mjml",
        callback = function()
          vim.bo.filetype = "mjml"
          vim.bo.shiftwidth = 2
          vim.bo.tabstop = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = "<!-- %s -->"
        end
      })
    end,
  },
}
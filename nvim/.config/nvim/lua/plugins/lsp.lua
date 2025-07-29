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
          "html",  -- Added for MJML support
          "cssls", -- Added for MJML support
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

      -- MJML-specific completion items
      local mjml_completions = {
        -- Core components
        { label = "mjml",              kind = 9, detail = "Root MJML element" },
        { label = "mj-head",           kind = 9, detail = "MJML head section" },
        { label = "mj-body",           kind = 9, detail = "MJML body section" },
        { label = "mj-section",        kind = 9, detail = "Email section" },
        { label = "mj-column",         kind = 9, detail = "Column within section" },
        { label = "mj-group",          kind = 9, detail = "Group columns" },
        { label = "mj-wrapper",        kind = 9, detail = "Wrapper element" },

        -- Content components
        { label = "mj-text",           kind = 9, detail = "Text content" },
        { label = "mj-button",         kind = 9, detail = "Button element" },
        { label = "mj-image",          kind = 9, detail = "Image element" },
        { label = "mj-divider",        kind = 9, detail = "Divider line" },
        { label = "mj-spacer",         kind = 9, detail = "Spacing element" },
        { label = "mj-table",          kind = 9, detail = "Table element" },
        { label = "mj-raw",            kind = 9, detail = "Raw HTML" },

        -- Navigation
        { label = "mj-navbar",         kind = 9, detail = "Navigation bar" },
        { label = "mj-navbar-link",    kind = 9, detail = "Navigation link" },

        -- Social
        { label = "mj-social",         kind = 9, detail = "Social media icons" },
        { label = "mj-social-element", kind = 9, detail = "Social media link" },

        -- Media
        { label = "mj-hero",           kind = 9, detail = "Hero section" },
        { label = "mj-carousel",       kind = 9, detail = "Image carousel" },
        { label = "mj-carousel-image", kind = 9, detail = "Carousel image" },

        -- Head elements
        { label = "mj-title",          kind = 9, detail = "Email title" },
        { label = "mj-preview",        kind = 9, detail = "Email preview text" },
        { label = "mj-attributes",     kind = 9, detail = "Global attributes" },
        { label = "mj-all",            kind = 9, detail = "Apply to all components" },
        { label = "mj-class",          kind = 9, detail = "CSS class definition" },
        { label = "mj-style",          kind = 9, detail = "Inline CSS styles" },
      }

      -- MJML-specific on_attach function
      local mjml_on_attach = function(client, bufnr)
        -- Common LSP keymaps
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
        vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })

        -- MJML-specific keymaps
        vim.keymap.set('n', '<leader>mv', function()
          local filename = vim.fn.expand('%:p')
          local cmd = string.format('mjml --validate "%s"', filename)
          local output = vim.fn.system(cmd)

          if vim.v.shell_error == 0 then
            print('MJML is valid!')
          else
            print('MJML validation errors:')
            print(output)
          end
        end, { buffer = bufnr, desc = 'Validate MJML' })

        vim.keymap.set('n', '<leader>mc', function()
          local filename = vim.fn.expand('%:p')
          local output_file = vim.fn.expand('%:p:r') .. '.html'
          local cmd = string.format('mjml "%s" -o "%s"', filename, output_file)

          vim.fn.system(cmd)
          if vim.v.shell_error == 0 then
            print('MJML compiled successfully to ' .. output_file)
          else
            print('MJML compilation failed')
          end
        end, { buffer = bufnr, desc = 'Compile MJML to HTML' })

        vim.keymap.set('n', '<leader>mp', function()
          local html_file = vim.fn.expand('%:p:r') .. '.html'
          if vim.fn.filereadable(html_file) == 1 then
            local cmd = string.format('open "%s"', html_file) -- macOS
            -- For Linux, use: local cmd = string.format('xdg-open "%s"', html_file)
            -- For Windows, use: local cmd = string.format('start "%s"', html_file)
            vim.fn.system(cmd)
          else
            print('HTML file not found. Compile MJML first with <leader>mc')
          end
        end, { buffer = bufnr, desc = 'Preview HTML in browser' })
      end

      -- Common on_attach function for all LSP servers
      local on_attach = function(client, bufnr)
        -- Common LSP keymaps
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
        vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })

        -- TypeScript/JavaScript specific keymaps - only set up once for vtsls
        if client.name == "vtsls" then
          local keymap_opts = { buffer = bufnr, silent = true }

          -- Method 1: Using vtsls commands (preferred)
          local ok, vtsls = pcall(require, "vtsls")
          if ok then
            vim.keymap.set("n", "<leader>co", function()
              vtsls.commands.organize_imports(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Organize Imports (vtsls)" }))

            vim.keymap.set("n", "<leader>cu", function()
              vtsls.commands.remove_unused_imports(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Remove Unused Imports (vtsls)" }))

            vim.keymap.set("n", "<leader>cr", function()
              vtsls.commands.remove_unused(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Remove Unused (vtsls)" }))

            vim.keymap.set("n", "<leader>cm", function()
              vtsls.commands.add_missing_imports(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Add Missing Imports (vtsls)" }))

            vim.keymap.set("n", "<leader>cf", function()
              vtsls.commands.fix_all(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Fix All (vtsls)" }))

            vim.keymap.set("n", "<leader>cA", function()
              vtsls.commands.source_actions(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Source Actions (vtsls)" }))

            vim.keymap.set("n", "<leader>cR", function()
              vtsls.commands.rename_file(bufnr)
            end, vim.tbl_extend("force", keymap_opts, { desc = "Rename File (vtsls)" }))
          else
            -- Method 2: Fallback using LSP code actions
            vim.keymap.set("n", "<leader>co", function()
              vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" } },
                filter = function(action)
                  return action.title and
                      (action.title:match("Organize Imports") or action.kind == "source.organizeImports")
                end,
                apply = true,
              })
            end, vim.tbl_extend("force", keymap_opts, { desc = "Organize Imports (fallback)" }))

            vim.keymap.set("n", "<leader>cu", function()
              vim.lsp.buf.code_action({
                context = { only = { "source.removeUnused" } },
                filter = function(action)
                  return action.title and (action.title:match("Remove unused") or action.kind == "source.removeUnused")
                end,
                apply = true,
              })
            end, vim.tbl_extend("force", keymap_opts, { desc = "Remove Unused Imports (fallback)" }))
          end
        end

        -- Disable ESLint formatting to avoid conflicts
        if client.name == "eslint" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end

      -- Get LSP capabilities with error handling
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink_cmp = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink_cmp.get_lsp_capabilities(capabilities)
      end

      -- Server configurations
      local servers = {
        -- TypeScript/JavaScript
        vtsls = {
          filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
          root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
          single_file_support = true,
          init_options = {
            preferences = {
              -- Ensure vtsls takes priority for imports and refactoring
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
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              preferences = {
                importModuleSpecifier = "project-relative",
                includePackageJsonAutoImports = "auto",
              },
              suggest = {
                autoImports = true,
              },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- Angular
        angularls = {
          filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
          root_dir = lspconfig.util.root_pattern("angular.json", "project.json", "nx.json"),
          single_file_support = false,
          on_attach = function(client, bufnr)
            -- Disable conflicting capabilities but keep Angular-specific ones
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            -- For TypeScript files, let vtsls handle most language features
            local filetype = vim.bo[bufnr].filetype
            if filetype == "typescript" or filetype == "typescriptreact" then
              client.server_capabilities.hoverProvider = false
              client.server_capabilities.definitionProvider = false
              client.server_capabilities.referencesProvider = false
              client.server_capabilities.documentSymbolProvider = false
              client.server_capabilities.workspaceSymbolProvider = false
              client.server_capabilities.completionProvider = false
              client.server_capabilities.signatureHelpProvider = false
            end

            -- Set up common keymaps
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
            vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
          end,
        },

        -- HTML (for MJML support)
        html = {
          filetypes = { "html", "mjml" },
          settings = {
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                unformatted =
                "wbr,mj-text,mj-button,mj-image,mj-section,mj-column,mj-divider,mj-spacer,mj-hero,mj-carousel,mj-carousel-image,mj-social,mj-social-element,mj-navbar,mj-navbar-link,mj-raw,mj-wrapper,mj-group,mj-style,mj-head,mj-title,mj-preview,mj-attributes,mj-all,mj-body,mj-class",
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
            }
          },
          on_attach = function(client, bufnr)
            local filetype = vim.bo[bufnr].filetype
            if filetype == "mjml" then
              mjml_on_attach(client, bufnr)
            else
              on_attach(client, bufnr)
            end
          end,
        },

        -- CSS (for MJML inline styles)
        cssls = {
          filetypes = { "css", "scss", "less", "mjml" },
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

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" }
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },

        -- ESLint
        eslint = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
          settings = {
            format = { enable = false }, -- Disable formatting to avoid conflicts
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

        -- Emmet (now includes MJML)
        emmet_ls = {
          filetypes = {
            "html", "css", "scss", "sass", "less", "mjml",
            "javascript", "javascriptreact", "typescript", "typescriptreact"
          },
        },

        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
      }

      -- Utility function to get Angular Language Server command for Nx workspaces
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
        -- Don't use common on_attach for angularls or html since they have their own
        if server ~= "angularls" and server ~= "html" then
          config.on_attach = on_attach
        end
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

      -- MJML filetype detection and configuration
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

      -- Setup blink.cmp for MJML completions
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mjml",
        callback = function()
          local ok, blink_cmp = pcall(require, "blink.cmp")
          if ok then
            -- Add MJML-specific completions to blink.cmp
            -- Note: This is a simplified approach - you may need to adjust based on blink.cmp's API
            vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
            print("MJML mode activated. Use <leader>m[v,c,p] for MJML commands")
          end
        end
      })
    end,
  },
}

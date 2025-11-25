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
          cmd = { "vtsls", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_markers = { "nx.json", "angular.json", "package.json", ".git" },
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
          cmd = { "ngserver", "--stdio", "--tsProbeLocations", ".", "--ngProbeLocations", "." },
          filetypes = {
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "htmlangular",
          },
          root_markers = { "angular.json", "nx.json" },
          single_file_support = false,
        },
        eslint = {
          cmd = { "vscode-eslint-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "htmlangular" },
          root_markers = {
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "package.json",
          },
          settings = { format = { enable = false }, run = "onSave" },
        },
        html = {
          cmd = { "vscode-html-language-server", "--stdio" },
          filetypes = { "html", "mjml" },
          root_markers = { "package.json", ".git" },
        },
        cssls = {
          cmd = { "vscode-css-language-server", "--stdio" },
          filetypes = { "css", "scss", "less" },
          root_markers = { "package.json", ".git" },
        },
        emmet_ls = {
          cmd = { "emmet-ls", "--stdio" },
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_markers = { "package.json", ".git" },
        },
        jsonls = {
          cmd = { "vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc" },
          root_markers = { ".git" },
        },
        lua_ls = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
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
        -- Copilot LSP (for Sidekick NES support)
        -- Install via :MasonInstall copilot-language-server
        copilot = {},
      },
    },
    config = function(_, opts)
      -- Setup Mason for LSP installation
      require("mason").setup()
      -- Exclude servers not in mason-lspconfig mappings
      local mason_exclude = { copilot = true }
      local mason_servers = vim.tbl_filter(function(s)
        return not mason_exclude[s]
      end, vim.tbl_keys(opts.servers))
      require("mason-lspconfig").setup({
        ensure_installed = mason_servers,
        automatic_installation = true,
      })

      -- Configure diagnostics globally
      vim.diagnostic.config(opts.diagnostics)

      -- Custom keybindings (Neovim 0.11 provides grn, gra, grr, gri, gO, <C-S> by default)
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
      vim.keymap.set("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle inlay hints" })
      vim.keymap.set("n", "<leader>cr", function()
        require("vtsls").commands.remove_unused_imports(0)
      end, { desc = "Remove unused imports" })
      vim.keymap.set("n", "<leader>co", function()
        require("vtsls").commands.organize_imports(0)
      end, { desc = "Organize imports" })

      -- Setup vtsls move-to-file functionality
      local function setup_vtsls_move_to_file(client)
        client.commands["_typescript.moveToFileRefactoring"] = function(command)
          ---@type string, string, lsp.Range
          local action, uri, range = unpack(command.arguments)

          local function move(newf)
            client.request("workspace/executeCommand", {
              command = command.command,
              arguments = { action, uri, range, newf },
            })
          end

          local fname = vim.uri_to_fname(uri)
          client.request("workspace/executeCommand", {
            command = "typescript.tsserverRequest",
            arguments = {
              "getMoveToRefactoringFileSuggestions",
              {
                file = fname,
                startLine = range.start.line + 1,
                startOffset = range.start.character + 1,
                endLine = range["end"].line + 1,
                endOffset = range["end"].character + 1,
              },
            },
          }, function(_, result)
            ---@type string[]
            local files = result.body.files
            table.insert(files, 1, "Enter new path...")
            vim.ui.select(files, {
              prompt = "Select move destination:",
              format_item = function(f)
                return vim.fn.fnamemodify(f, ":~:.")
              end,
            }, function(f)
              if f and f:find("^Enter new path") then
                vim.ui.input({
                  prompt = "Enter move destination:",
                  default = vim.fn.fnamemodify(fname, ":h") .. "/",
                  completion = "file",
                }, function(newf)
                  return newf and move(newf)
                end)
              elseif f then
                move(f)
              end
            end)
          end)
        end
      end

      -- Configure servers using Neovim 0.11 native vim.lsp.config
      for server, config in pairs(opts.servers) do
        -- Setup capabilities from blink.cmp
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }

        -- Prepare config for vim.lsp.config
        local lsp_config = vim.tbl_extend("force", {
          capabilities = capabilities,
        }, config)

        -- Special handling for specific servers
        if server == "vtsls" then
          lsp_config.settings.javascript =
            vim.tbl_deep_extend("force", {}, lsp_config.settings.typescript, lsp_config.settings.javascript or {})

          -- Add on_attach for move-to-file functionality
          local original_on_attach = lsp_config.on_attach
          lsp_config.on_attach = function(client, bufnr)
            setup_vtsls_move_to_file(client)
            if original_on_attach then
              original_on_attach(client, bufnr)
            end
          end
        elseif server == "jsonls" then
          local ok, schemastore = pcall(require, "schemastore")
          if ok then
            lsp_config.settings = {
              json = {
                schemas = schemastore.json.schemas(),
              },
            }
          end
        end

        -- Use vim.lsp.config (native Neovim 0.11 API)
        vim.lsp.config(server, lsp_config)
      end

      -- Enable all configured servers
      vim.lsp.enable(vim.tbl_keys(opts.servers))

      -- LspAttach autocmd for per-buffer configuration
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          local bufnr = args.buf

          -- Enable LSP-based completion (Neovim 0.11 native)
          vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

          -- Enable LSP-based folding (window-local options)
          if client.supports_method("textDocument/foldingRange") then
            local win = vim.fn.bufwinid(bufnr)
            if win ~= -1 then
              vim.wo[win].foldmethod = "expr"
              vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
              vim.wo[win].foldenable = false
            end
          end

          -- Inlay hints: disabled by default due to TypeScript 5.7.x bug with computed properties
          -- Toggle with: vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          -- or use the keymap below
        end,
      })
    end,
  },
}

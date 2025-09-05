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
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        automatic_installation = true,
        automatic_enable = false,
      })
      vim.diagnostic.config(opts.diagnostics)

      -- Set up LSP keymaps
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "Signature Help" })
      vim.keymap.set("n", "<leader>cr", function() require('vtsls').commands.remove_unused_imports(0) end, { desc = "Remove unused imports" })
      vim.keymap.set("n", "<leader>co", function() require('vtsls').commands.organize_imports(0) end, { desc = "Organize imports" })

      -- Setup vtsls with special move-to-file functionality
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

      for server, config in pairs(opts.servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        config.capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }

        if server == "vtsls" then
          config.settings.javascript = vim.tbl_deep_extend("force", {}, config.settings.typescript,
            config.settings.javascript or {})

          -- Setup with move-to-file functionality
          config.on_attach = function(client)
            setup_vtsls_move_to_file(client)
          end
        end

        lspconfig[server].setup(config)
      end
    end,
  },
}

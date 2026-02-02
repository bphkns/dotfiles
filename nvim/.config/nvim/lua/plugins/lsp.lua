return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
      "yioneko/nvim-vtsls",
    },
    opts = {
      diagnostics = {
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
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
          settings = {
            complete_function_calls = false,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 40,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
              tsserver = {
                globalPlugins = {},
                pluginPaths = { "node_modules" },
              },
            },
            typescript = {
              preferences = {
                importModuleSpecifier = "relative",
                includePackageJsonAutoImports = "on",
              },
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = false,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
              },
            },
          },
        },
        angularls = {
          -- Custom root detection for Nx/Angular
          root_dir = function(bufnr)
            -- Get the actual filename from buffer number
            local fname = vim.api.nvim_buf_get_name(bufnr)

            -- Skip non-file buffers (like oil://)
            if not fname or fname == "" or fname:match("^%w+://") then
              return nil
            end

            -- Check for angular.json first (standard Angular project)
            local angular_root = vim.fs.root(fname, { "angular.json" })
            if angular_root then
              return angular_root
            end

            -- For Nx projects, check for nx.json AND @angular/core in package.json
            local nx_root = vim.fs.root(fname, { "nx.json" })
            if nx_root then
              local pkg_path = vim.fs.joinpath(nx_root, "package.json")
              local file = io.open(pkg_path, "r")
              if file then
                local content = file:read("*a")
                file:close()
                local ok, pkg = pcall(vim.json.decode, content)
                if ok and pkg then
                  local deps = pkg.dependencies or {}
                  local dev_deps = pkg.devDependencies or {}
                  if deps["@angular/core"] or dev_deps["@angular/core"] then
                    return nx_root
                  end
                end
              end
            end

            return nil
          end,
        },
        biome = {
          -- Biome LSP for formatting and linting
          root_dir = function(bufnr)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if not fname or fname == "" or fname:match("^%w+://") then
              return nil
            end
            -- Look for biome.json or biome.jsonc
            return vim.fs.root(fname, { "biome.json", "biome.jsonc" })
          end,
        },
        eslint = {
          settings = {
            format = { enable = true },
            run = "onSave",
          },
        },
        html = {
          filetypes = { "html", "mjml" }, -- Added mjml as per original
        },
        cssls = {},
        emmet_ls = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Setup Mason for LSP installation
      require("mason").setup()
      local mason_servers = vim.tbl_keys(opts.servers)

      require("mason-lspconfig").setup({
        ensure_installed = mason_servers,
        automatic_installation = true,
      })

      -- Install formatters and linters via mason-tool-installer
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettierd",
          "stylua",
        },
      })

      -- Configure diagnostics globally
      vim.diagnostic.config(opts.diagnostics)

      -- Custom keybindings
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
            if not result or not result.body or not result.body.files then
              return
            end
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
      -- vim.lsp.config auto-discovers defaults from lsp/*.lua in nvim-lspconfig
      for server, server_opts in pairs(opts.servers) do
        -- Setup capabilities from blink.cmp
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }

        -- Merge capabilities with user options (vim.lsp.config handles lspconfig defaults)
        local lsp_config = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, server_opts)

        -- Special handling for specific servers
        if server == "vtsls" then
          lsp_config.settings.javascript =
            vim.tbl_deep_extend("force", {}, lsp_config.settings.typescript, lsp_config.settings.javascript or {})

          -- Disable formatting from vtsls, let ESLint handle it
          lsp_config.on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end

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
            lsp_config.settings = vim.tbl_deep_extend("force", lsp_config.settings or {}, {
              json = {
                schemas = schemastore.json.schemas(),
              },
            })
          end
        end

        -- Correct 0.11 API usage: Assign to the registry
        vim.lsp.config[server] = lsp_config
      end

      -- Enable all configured servers
      for server, _ in pairs(opts.servers) do
        vim.lsp.enable(server)
      end

      -- LspAttach autocmd for per-buffer configuration
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          local bufnr = args.buf

          -- Enable inlay hints if supported
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          if client.server_capabilities.foldingRangeProvider then
            local win = vim.fn.bufwinid(bufnr)
            if win ~= -1 then
              vim.wo[win].foldmethod = "expr"
              vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
              vim.wo[win].foldenable = false
            end
          end

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "gd", function()
            require("fzf-lua").lsp_definitions()
          end, "Goto Definition")

          map("n", "gr", function()
            require("fzf-lua").lsp_references()
          end, "References")

          map("n", "gI", function()
            require("fzf-lua").lsp_implementations()
          end, "Goto Implementation")

          map("n", "gy", function()
            require("fzf-lua").lsp_typedefs()
          end, "Goto Type Definition")

          map("n", "<leader>ca", function()
            require("fzf-lua").lsp_code_actions({ previewer = false })
          end, "Code Actions")

          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")

          map("n", "<leader>ds", function()
            require("fzf-lua").lsp_document_symbols()
          end, "Document Symbols")

          map("n", "<leader>ws", function()
            require("fzf-lua").lsp_workspace_symbols()
          end, "Workspace Symbols")
        end,
      })
    end,
  },
}

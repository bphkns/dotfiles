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
    opts = {
      ensure_installed = {
        "angularls",
        "emmet_ls",
        "jsonls",
        "vtsls",
        "lua_ls",
        "eslint",
      },
      servers = {
        vtsls = {},
        angularls = {},
        emmet_ls = {},
        jsonls = {},
        lua_ls = {},
        eslint = {
          settings = {
            format = { enable = false },
            workingDirectories = { mode = "auto" },
            run = "onType",
          },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local util = require("lspconfig.util")

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = { prefix = "●", source = "if_many" },
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })


      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

      -- Common on_attach
      local on_attach = function(client, bufnr)
        local bufopts = { buffer = bufnr }
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
          vim.tbl_extend("force", bufopts, { desc = "Rename Symbol" }))
        vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help,
          vim.tbl_extend("force", bufopts, { desc = "Signature Help" }))

        -- Debug: Print client name
        print("LSP client attached:", client.name)


        -- VTSLS specific keymaps
        if client.name == "vtsls" then
          -- Check if vtsls module is available
          local vtsls_ok, vtsls = pcall(require, "vtsls")
          if vtsls_ok then
            -- Import organization
            vim.keymap.set("n", "<leader>co", function()
              vtsls.commands.organize_imports(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Organize Imports" }))

            vim.keymap.set("n", "<leader>cs", function()
              vtsls.commands.sort_imports(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Sort Imports" }))

            vim.keymap.set("n", "<leader>cu", function()
              vtsls.commands.remove_unused_imports(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Remove Unused Imports" }))

            vim.keymap.set("n", "<leader>cr", function()
              vtsls.commands.remove_unused(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Remove Unused" }))

            vim.keymap.set("n", "<leader>cm", function()
              vtsls.commands.add_missing_imports(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Add Missing Imports" }))

            vim.keymap.set("n", "<leader>cf", function()
              vtsls.commands.fix_all(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Fix All" }))

            -- Source actions (whole buffer actions)
            vim.keymap.set("n", "<leader>cA", function()
              vtsls.commands.source_actions(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Source Actions" }))

            -- File operations
            vim.keymap.set("n", "<leader>cR", function()
              vtsls.commands.rename_file(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Rename File" }))

            -- Navigation
            vim.keymap.set("n", "gd", function()
              vtsls.commands.goto_source_definition(vim.api.nvim_get_current_win())
            end, vim.tbl_extend("force", bufopts, { desc = "Goto Source Definition" }))

            vim.keymap.set("n", "<leader>cF", function()
              vtsls.commands.file_references(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "File References" }))

            -- TypeScript server commands
            vim.keymap.set("n", "<leader>cT", function()
              vtsls.commands.select_ts_version(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Select TS Version" }))

            vim.keymap.set("n", "<leader>cP", function()
              vtsls.commands.goto_project_config(bufnr)
            end, vim.tbl_extend("force", bufopts, { desc = "Goto Project Config" }))

            print("VTSLS keymaps set successfully")
          else
            print("VTSLS module not available:", vtsls)
          end
        end

        -- Disable ESLint formatting
        if client.name == "eslint" then
          client.server_capabilities.documentFormattingProvider = false
        end
      end

      -- Setup Mason
      mason.setup()
      mason_lspconfig.setup({ ensure_installed = opts.ensure_installed })

      -- Angular LS setup
      local function get_angular_ls_path()
        local workspace_root = util.root_pattern("nx.json")(vim.fn.getcwd())
        if workspace_root then
          return workspace_root .. "/node_modules/@angular/language-server"
        end
        return nil
      end

      local angular_ls_path = get_angular_ls_path()
      if angular_ls_path then
        opts.servers.angularls.root_dir = function(fname)
          return util.root_pattern("angular.json", "nx.json")(fname)
        end
        opts.servers.angularls.filetypes = { "typescript", "html", "typescriptreact" }
        opts.servers.angularls.cmd = {
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

      -- VTSLS setup with enhanced configuration
      lspconfig.vtsls.setup({
        on_attach = on_attach,
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        settings = {
          typescript = {
            preferences = { importModuleSpecifier = "project-relative" },
            diagnostics = { ignoredCodes = { 6133, 6196 } }, -- Avoid ESLint overlap
          },
        },
      })

      -- Lua LS setup
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true },
              checkThirdParty = false
            },
          },
        },
      })

      -- Setup remaining servers
      for server, config in pairs(opts.servers) do
        if server ~= "vtsls" and server ~= "lua_ls" then
          config.on_attach = on_attach
          config.capabilities = require("blink.cmp").get_lsp_capabilities()
          lspconfig[server].setup(config)
        end
      end
    end,
  },
}

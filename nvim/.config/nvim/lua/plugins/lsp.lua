return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      ensure_installed = {
        "nxls",
        "angularls",
        "prettier",
        "emmet_ls",
        "json_ls",
        "vtsls",
      },
      servers = {
        vtsls = {
          settings = {
            complete_function_calls = false,
            typescript = {
              inlayHints = false,
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local util = require("lspconfig.util")
      local function get_angular_ls_path()
        local workspace_root = util.root_pattern("nx.json")(vim.fn.getcwd())
        if workspace_root then
          return workspace_root .. "/node_modules/@angular/language-server"
        end
        return nil
      end

      local angular_ls_path = get_angular_ls_path()
      if angular_ls_path then
        opts.servers.angularls = opts.servers.angularls or {}
        opts.servers.angularls.root_dir = function(fname)
          return util.root_pattern("angular.json", "nx.json")(fname)
        end
        opts.servers.angularls.filetypes =
          { "angular", "html", "typescript", "typescriptreact", "htmlangular", "typescript.tsx" }
        LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
          {
            name = "@angular/language-server",
            location = angular_ls_path,
            enableForWorkspaceTypeScriptVersions = true,
          },
        })
      else
      end
    end,
    setup = {
      angularls = function()
        LazyVim.lsp.on_attach(function(client)
          --HACK: disable angular renaming capability due to duplicate rename popping up
          client.server_capabilities.renameProvider = false
        end, "angularls")
      end,
    },
  },
}

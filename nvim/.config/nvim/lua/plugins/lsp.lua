return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      ensure_installed = {
        "nxls",
        "angularls",
        "prettier",
      },
      servers = {
        angularls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- Look for nx.json in parent directories
            return util.root_pattern("nx.json")(fname) or util.root_pattern("angular.json", "project.json")(fname)
          end,
        },
        vtsls = {
          settings = {
            complete_function_calls = false,
            typescript = {
              suggest = {
                completeFunctionCalls = false,
              },
            },
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@angular/language-server",
          location = LazyVim.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server"),
          enableForWorkspaceTypeScriptVersions = false,
        },
      })
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

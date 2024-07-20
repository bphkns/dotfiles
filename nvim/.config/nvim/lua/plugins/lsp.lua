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
          filetypes = { "angular", "html", "typescript", "typescriptreact", "typescript.tsx", "htmlangular" },
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
        opts.servers.angularls.cmd = {
          "ngserver",
          "--stdio",
          "--tsProbeLocations",
          angular_ls_path .. "/node_modules",
          "--ngProbeLocations",
          angular_ls_path .. "/node_modules",
        }
        LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
          {
            name = "@angular/language-server",
            location = angular_ls_path,
            enableForWorkspaceTypeScriptVersions = false,
          },
        })
      else
        vim.notify(
          "Could not find Angular Language Server. Make sure it's installed in your project.",
          vim.log.levels.WARN
        )
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

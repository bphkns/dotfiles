return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "haydenmeade/neotest-jest",
      { "marilari88/neotest-vitest", branch = "main" },
    },
    event = "VeryLazy",
    keys = {
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      { "<leader>t", "", desc = "+test" },
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File (Neotest)",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files (Neotest)",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest (Neotest)",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary (Neotest)",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output (Neotest)",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel (Neotest)",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop (Neotest)",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Watch (Neotest)",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestConfigFile = function(path)
              local util = require("neotest-vitest.util")
              local vite_config_path = util.search_ancestors(path, function(ancestor_path)
                return util.path.exists(ancestor_path .. "/jest.config.ts")
              end)
              local vite_config_file = vite_config_path .. "/jest.config.ts"
              if util.path.exists(vite_config_file) then
                return vite_config_file
              end
              return vim.fn.getcwd() .. "/jest.config.ts"
            end,
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-vitest")({
            vitestConfigFile = function(path)
              local util = require("neotest-vitest.util")
              local vite_config_path = util.search_ancestors(path, function(ancestor_path)
                return util.path.exists(ancestor_path .. "/vite.config.ts")
              end)
              local vite_config_file = vite_config_path .. "/vite.config.ts"
              if util.path.exists(vite_config_file) then
                return vite_config_file
              end
              return vim.fn.getcwd() .. "/vite.config.ts"
            end,
          }),
        },
      })
    end,
  },
}

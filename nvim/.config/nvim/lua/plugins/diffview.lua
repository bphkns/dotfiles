local function get_default_branch_name()
  local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
  return res.code == 0 and "main" or "master"
end

return {
  {
    "sindrets/diffview.nvim",
    lazy = true,
    opts = function(_, opts)
      opts.view.file_history = {
        layout = "diff2_vertical",
      }
      opts.view.default = {
        layout = "diff2_vertical",
      }
    end,
    keys = {
      { ",gd", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
      { ",gc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
      { ",gr", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
      { ",gf", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "File history" },
      { ",gv", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", mode = "v", desc = "Range history" },
      { ",gl", "<Cmd>.DiffviewFileHistory --follow<CR>", desc = "Line history" },
      {
        ",gm",
        function()
          vim.cmd("DiffviewOpen " .. get_default_branch_name())
        end,
        desc = "Compare local main",
      },
      {
        ",gM",
        function()
          vim.cmd("DiffviewOpen HEAD..origin/" .. get_default_branch_name())
        end,
        desc = "Compare remote main",
      },
    },
  },
}

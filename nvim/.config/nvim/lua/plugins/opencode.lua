return {
  "NickvanDyke/opencode.nvim",
  keys = {
    { "<leader>aa", desc = "Ask opencode" },
    { "<leader>ax", desc = "Execute opencode action" },
    { "<leader>at", desc = "Toggle opencode" },
  },
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {}

    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>ax", function() require("opencode").select() end, { desc = "Execute opencode action" })
    vim.keymap.set({ "n", "t" }, "<leader>at", function() require("opencode").toggle() end, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "<leader>ago", function() return require("opencode").operator("@this ") end, { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "<leader>agoo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })
  end,
}

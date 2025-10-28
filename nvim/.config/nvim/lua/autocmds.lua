-- Autocommands configuration

-- Auto-source .dadbod.lua for project-specific database connections
local dadbod_group = vim.api.nvim_create_augroup("DadbodConfig", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  group = dadbod_group,
  callback = function()
    local dadbod_config = vim.fn.getcwd() .. "/.dadbod.lua"
    if vim.fn.filereadable(dadbod_config) == 1 then
      vim.cmd("source " .. dadbod_config)
      vim.notify("Loaded .dadbod.lua configuration", vim.log.levels.INFO)
    end
  end,
  desc = "Auto-source .dadbod.lua when entering or changing directories",
})

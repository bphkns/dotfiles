local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("options")
require("keymaps")
require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Load plugin specs from the 'plugins' directory
  },
  defaults = {
    lazy = true,
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
})

vim.api.nvim_create_user_command("EditLineFromLazygit", function(opts)
  local filepath, line = opts.args:match("^(.+)%s+(%d+)$")
  if filepath and line then
    vim.cmd("e " .. vim.fn.fnameescape(filepath))
    vim.cmd(line)
  end
end, { nargs = "+" })

vim.api.nvim_create_user_command("EditFromLazygit", function(opts)
  vim.cmd("e " .. vim.fn.fnameescape(opts.args))
end, { nargs = 1 })

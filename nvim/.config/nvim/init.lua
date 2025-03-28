local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set mapleader before lazy
vim.g.mapleader = " " -- Use space as leader key
vim.g.maplocalleader = ","

require('options')
require('keymaps')

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Load plugin specs from the 'plugins' directory
  },
  defaults = {
    lazy = true, -- Lazy-load all plugins
    version = "*", -- Use latest version for all plugins
  },
})

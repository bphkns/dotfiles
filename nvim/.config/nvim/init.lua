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

require("options")
require("keymaps")

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Load plugin specs from the 'plugins' directory
  },
  defaults = {
    lazy = true, -- Lazy-load all plugins
    version = "*", -- Use latest version for all plugins
  },
})

function EditLineFromLazygit(file_path, line)
  local path = vim.fn.expand("%:p")
  if path == file_path then
    vim.cmd(tostring(line))
  else
    vim.cmd("e " .. file_path)
    vim.cmd(tostring(line))
  end
end

function EditFromLazygit(file_path)
  local path = vim.fn.expand("%:p")
  if path == file_path then
    return
  else
    vim.cmd("e " .. file_path)
  end
end

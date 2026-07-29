local function omarchy_colorscheme(reload)
  if reload then
    package.loaded["plugins.theme"] = nil
  end

  local ok, theme_specs = pcall(require, "plugins.theme")
  if not ok or type(theme_specs) ~= "table" then
    return nil
  end

  for _, spec in ipairs(theme_specs) do
    if spec[1] == "LazyVim/LazyVim" and type(spec.opts) == "table" then
      local colorscheme = spec.opts.colorscheme
      if type(colorscheme) == "string" and colorscheme ~= "" then
        return colorscheme
      end
    end
  end

  return nil
end

local function apply_omarchy_colorscheme(reload)
  local colorscheme = omarchy_colorscheme(reload)
  if colorscheme then
    local ok_loader, loader = pcall(require, "lazy.core.loader")
    if ok_loader then
      pcall(loader.colorscheme, colorscheme)
    end

    local ok_colorscheme = pcall(vim.cmd.colorscheme, colorscheme)
    if ok_colorscheme then
      return
    end
  end

  vim.cmd.colorscheme("habamax")
  vim.notify("Could not load the current Omarchy Neovim theme; using habamax", vim.log.levels.WARN)
end

return {
  -- Omarchy theme files use LazyVim opts as theme metadata. This config is not LazyVim.
  { "LazyVim/LazyVim", enabled = false },
  {
    name = "omarchy-theme",
    -- Keep this distinct from Omarchy's theme-hotreload local plugin.
    dir = vim.fn.stdpath("config") .. "/lua/plugins",
    lazy = false,
    priority = 10000,
    config = function()
      apply_omarchy_colorscheme(false)

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("UserOmarchyTheme", { clear = true }),
        pattern = "LazyReload",
        callback = function()
          -- Run after Omarchy's generated hot-reloader has updated plugin specs.
          vim.defer_fn(function()
            apply_omarchy_colorscheme(true)
          end, 100)
        end,
      })
    end,
  },
}

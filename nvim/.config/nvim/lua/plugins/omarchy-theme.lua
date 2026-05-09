local function omarchy_colorscheme()
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

return {
  -- Omarchy theme files use LazyVim opts as theme metadata. This config is not LazyVim.
  { "LazyVim/LazyVim", enabled = false },
  {
    name = "omarchy-theme",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 10000,
    config = function()
      local colorscheme = omarchy_colorscheme()
      if not colorscheme then
        return
      end

      local ok_loader, loader = pcall(require, "lazy.core.loader")
      if ok_loader then
        pcall(loader.colorscheme, colorscheme)
      end

      pcall(vim.cmd.colorscheme, colorscheme)
    end,
  },
}

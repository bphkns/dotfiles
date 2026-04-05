-- MJML-specific highlight groups based on official VS Code extension
local function set_mjml_highlights()
  vim.api.nvim_set_hl(0, "@tag.mjml.structure", { link = "Structure", bold = true })
  vim.api.nvim_set_hl(0, "@tag.mjml.layout", { link = "Function" })
  vim.api.nvim_set_hl(0, "@tag.mjml.content", { link = "Keyword" })
  vim.api.nvim_set_hl(0, "@tag.mjml.interactive", { link = "Special" })
  vim.api.nvim_set_hl(0, "@tag.mjml.special", { link = "PreProc" })
  vim.api.nvim_set_hl(0, "@attribute.mjml", { link = "Type" })
  vim.api.nvim_set_hl(0, "@variable.template", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@variable.template.angular", { link = "Macro" })
end

set_mjml_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_mjml_highlights,
})

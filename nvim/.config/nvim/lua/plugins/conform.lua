local slow_format_filetypes = {}

-- Check if file is in a project that uses ESLint for formatting (Effect/dprint)
-- by checking if .prettierignore exists and file would be ignored
local function is_eslint_project(ctx)
  local fname = ctx.filename
  -- Check if prettier would ignore this file by looking for eslint config with effect plugin
  local eslint_root = vim.fs.root(fname, { "eslint.config.mjs", "eslint.config.js" })
  if not eslint_root then
    return false
  end
  -- Check if prettier config exists - if not, use ESLint
  local prettier_root = vim.fs.root(fname, { ".prettierrc", "prettier.config.js", ".prettierrc.json" })
  if not prettier_root then
    return true
  end
  -- Check .prettierignore to see if this file should be ignored by prettier
  local ignore_file = prettier_root .. "/.prettierignore"
  local f = io.open(ignore_file, "r")
  if not f then
    return false
  end
  local content = f:read("*a")
  f:close()
  -- Get relative path from project root
  local rel_path = fname:sub(#prettier_root + 2)
  for line in content:gmatch("[^\r\n]+") do
    -- Skip comments and empty lines
    if not line:match("^#") and line ~= "" then
      -- Simple glob matching for patterns like "apps/api/**"
      local pattern = line:gsub("%*%*", ".*"):gsub("%*", "[^/]*")
      if rel_path:match("^" .. pattern) then
        return true
      end
    end
  end
  return false
end

return {
  {
    "stevearc/conform.nvim",
    event = { "VeryLazy" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        ["angular"] = { "biome", "prettierd", "prettier" },
        ["htmlangular"] = { "prettierd", "prettier" },
        ["javascript"] = { "biome", "prettierd", "prettier" },
        ["javascriptreact"] = { "biome", "prettierd", "prettier" },
        ["typescript"] = { "biome", "prettierd", "prettier" },
        ["typescriptreact"] = { "biome", "prettierd", "prettier" },
        ["vue"] = { "biome", "prettierd", "prettier" },
        ["css"] = { "biome", "prettierd", "prettier" },
        ["scss"] = { "prettierd", "prettier" },
        ["less"] = { "prettierd", "prettier" },
        ["html"] = { "prettierd", "prettier" },
        ["mjml"] = { "prettierd", "prettier" },
        ["json"] = { "biome", "prettierd", "prettier" },
        ["jsonc"] = { "biome", "prettierd", "prettier" },
        ["graphql"] = { "biome", "prettierd", "prettier" },
        ["yaml"] = { "prettierd", "prettier" },
        ["markdown"] = { "prettierd", "prettier" },
        ["markdown.mdx"] = { "prettierd", "prettier" },
        ["handlebars"] = { "prettierd", "prettier" },
        ["lua"] = { "stylua" },
      },
      formatters = {
        biome = {
          command = "biome",
          args = {
            "check",
            "--write",
            "--unsafe",
            "--stdin-file-path",
            "$FILENAME",
          },
          stdin = true,
          -- Only run biome if biome.json exists in project
          condition = function(_, ctx)
            return vim.fs.root(ctx.filename, { "biome.json", "biome.jsonc" }) ~= nil
          end,
        },
        prettierd = {
          -- Skip prettierd for ESLint/dprint projects
          condition = function(_, ctx)
            return not is_eslint_project(ctx)
          end,
        },
        prettier = {
          -- Skip prettier for ESLint/dprint projects
          condition = function(_, ctx)
            return not is_eslint_project(ctx)
          end,
        },
      },
      format_on_save = function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end

        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        local function on_format(err)
          if err and err:match("timeout$") then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        -- For ESLint/dprint projects, use LSP formatting directly
        local ctx = { filename = bufname, buf = bufnr }
        if is_eslint_project(ctx) then
          return { timeout_ms = 2000, lsp_format = "prefer" }, on_format
        end

        return { timeout_ms = 500, lsp_format = "fallback" }, on_format
      end,

      format_after_save = function(bufnr)
        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        local ctx = { filename = vim.api.nvim_buf_get_name(bufnr), buf = bufnr }
        if is_eslint_project(ctx) then
          return { lsp_format = "prefer" }
        end
        return { lsp_format = "fallback" }
      end,
    },
  },
}

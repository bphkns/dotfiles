local effect_project_cache = {}

local function is_effect_project(ctx)
  local dir = vim.fn.fnamemodify(ctx.filename, ":h")
  if effect_project_cache[dir] ~= nil then
    return effect_project_cache[dir]
  end

  -- Search ALL package.json files upward (monorepo support)
  local pkg_paths = vim.fs.find("package.json", {
    path = ctx.filename,
    upward = true,
    stop = vim.uv.os_homedir(),
    limit = math.huge,
  })

  for _, pkg_path in ipairs(pkg_paths) do
    local f = io.open(pkg_path, "r")
    if f then
      local content = f:read("*a")
      f:close()
      if content:match('"@effect/eslint%-plugin"') then
        effect_project_cache[dir] = true
        return true
      end
    end
  end

  effect_project_cache[dir] = false
  return false
end

vim.api.nvim_create_user_command("ConformDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = "Disable conform-autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("ConformEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Re-enable conform-autoformat-on-save" })

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        async = true,
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        return { async = true, timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        javascript = { "eslint_d", "biome", "prettierd", stop_after_first = true },
        javascriptreact = { "eslint_d", "biome", "prettierd", stop_after_first = true },
        typescript = { "eslint_d", "biome", "prettierd", stop_after_first = true },
        typescriptreact = { "eslint_d", "biome", "prettierd", stop_after_first = true },
        vue = { "biome", "prettierd", stop_after_first = true },
        astro = { "biome", "prettierd", stop_after_first = true },
        angular = { "biome", "prettierd", stop_after_first = true },
        htmlangular = { "prettierd" },
        css = { "biome", "prettierd", stop_after_first = true },
        scss = { "prettierd" },
        less = { "prettierd" },
        html = { "prettierd" },
        mjml = { "prettierd" },
        json = { "biome", "prettierd", stop_after_first = true },
        jsonc = { "biome", "prettierd", stop_after_first = true },
        graphql = { "biome", "prettierd", stop_after_first = true },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        ["markdown.mdx"] = { "prettierd" },
        handlebars = { "prettierd" },
        lua = { "stylua" },
      },
      formatters = {
        eslint_d = {
          condition = function(_, ctx)
            return is_effect_project(ctx)
          end,
        },
        biome = {
          condition = function(_, ctx)
            return vim.fs.find({ "biome.json", "biome.jsonc" }, {
              path = ctx.filename,
              upward = true,
              stop = vim.uv.os_homedir(),
            })[1] ~= nil
          end,
        },
        prettierd = {
          condition = function(_, ctx)
            if is_effect_project(ctx) then
              return false
            end
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            }, { path = ctx.filename, upward = true, stop = vim.uv.os_homedir() })[1] ~= nil
          end,
        },
      },
    },
  },
}

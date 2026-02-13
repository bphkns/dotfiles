local effect_project_cache = {}
local prettier_project_cache = {}
local dprint_project_cache = {}
local tailwind_plugin_cache = {}

local function read_json(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()

  local ok, parsed = pcall(vim.json.decode, content)
  if not ok then
    return nil
  end

  return parsed
end

local function find_upward(filename, names)
  return vim.fs.find(names, {
    path = filename,
    upward = true,
    stop = vim.uv.os_homedir(),
    limit = 1,
  })[1]
end

local function is_effect_project(ctx)
  local dir = vim.fn.fnamemodify(ctx.filename, ":h")
  if effect_project_cache[dir] ~= nil then
    return effect_project_cache[dir]
  end

  local package_json = find_upward(ctx.filename, { "package.json" })
  if package_json then
    local pkg = read_json(package_json)
    if pkg then
      local deps = pkg.dependencies or {}
      local dev_deps = pkg.devDependencies or {}
      if deps["@effect/eslint-plugin"] or dev_deps["@effect/eslint-plugin"] then
        effect_project_cache[dir] = true
        return true
      end
      if deps["@tooling/api-eslint-config"] or dev_deps["@tooling/api-eslint-config"] then
        effect_project_cache[dir] = true
        return true
      end
    end
  end

  effect_project_cache[dir] = false
  return false
end

local function has_dprint_config(ctx)
  local dir = vim.fn.fnamemodify(ctx.filename, ":h")
  if dprint_project_cache[dir] ~= nil then
    return dprint_project_cache[dir]
  end

  local config = find_upward(ctx.filename, {
    "dprint.json",
    ".dprint.json",
    "dprint.jsonc",
    ".dprint.jsonc",
  })

  dprint_project_cache[dir] = config ~= nil
  return dprint_project_cache[dir]
end

local function has_prettier_config(ctx)
  local dir = vim.fn.fnamemodify(ctx.filename, ":h")
  if prettier_project_cache[dir] ~= nil then
    return prettier_project_cache[dir]
  end

  local config = find_upward(ctx.filename, {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.yaml",
    ".prettierrc.yml",
    ".prettierrc.json5",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
    "prettier.config.ts",
    "prettier.config.cts",
    "prettier.config.mts",
  })

  if config then
    prettier_project_cache[dir] = true
    return true
  end

  local package_json = find_upward(ctx.filename, { "package.json" })
  if package_json then
    local pkg = read_json(package_json)
    if pkg and pkg.prettier ~= nil then
      prettier_project_cache[dir] = true
      return true
    end
  end

  prettier_project_cache[dir] = false
  return false
end

local function prettier_cwd(ctx)
  local config = find_upward(ctx.filename, {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.yaml",
    ".prettierrc.yml",
    ".prettierrc.json5",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
    "prettier.config.ts",
    "prettier.config.cts",
    "prettier.config.mts",
  })
  if config then
    return vim.fs.dirname(config)
  end

  local package_json = find_upward(ctx.filename, { "package.json" })
  if package_json then
    local pkg = read_json(package_json)
    if pkg and pkg.prettier ~= nil then
      return vim.fs.dirname(package_json)
    end
  end

  return nil
end

local function find_tailwind_plugin(ctx)
  local dir = vim.fn.fnamemodify(ctx.filename, ":h")
  if tailwind_plugin_cache[dir] ~= nil then
    return tailwind_plugin_cache[dir] or nil
  end

  local local_plugin = find_upward(ctx.filename, {
    "node_modules/prettier-plugin-tailwindcss/dist/index.mjs",
  })
  if local_plugin then
    tailwind_plugin_cache[dir] = local_plugin
    return local_plugin
  end

  tailwind_plugin_cache[dir] = false
  return nil
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
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        javascript = { "dprint", "eslint_d", "biome", "prettierd", stop_after_first = true },
        javascriptreact = { "prettier_tailwind", "dprint", "eslint_d", "biome", "prettierd", stop_after_first = true },
        typescript = { "dprint", "eslint_d", "biome", "prettierd", stop_after_first = true },
        typescriptreact = { "prettier_tailwind", "dprint", "eslint_d", "biome", "prettierd", stop_after_first = true },
        vue = { "prettier_tailwind", "biome", "prettierd", stop_after_first = true },
        astro = { "prettier_tailwind", "biome", "prettierd", stop_after_first = true },
        angular = { "prettier_tailwind", "biome", "prettierd", stop_after_first = true },
        htmlangular = { "prettierd" },
        css = { "biome", "prettierd", stop_after_first = true },
        scss = { "prettierd" },
        less = { "prettierd" },
        html = { "prettier_tailwind", "prettierd", stop_after_first = true },
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
        prettier_tailwind = {
          command = function(_, ctx)
            local local_prettier = find_upward(ctx.filename, { "node_modules/.bin/prettier" })
            return local_prettier or "prettier"
          end,
          cwd = function(_, ctx)
            return prettier_cwd(ctx)
          end,
          args = function(_, ctx)
            return { "--stdin-filepath", "$FILENAME" }
          end,
          range_args = function(_, ctx)
            local util = require("conform.util")
            local start_offset, end_offset = util.get_offsets_from_range(ctx.buf, ctx.range)
            return {
              "--stdin-filepath",
              "$FILENAME",
              "--range-start=" .. start_offset,
              "--range-end=" .. end_offset,
            }
          end,
          condition = function(_, ctx)
            local plugin = find_tailwind_plugin(ctx)
            return has_prettier_config(ctx) and plugin ~= nil
          end,
        },
        dprint = {
          condition = function(_, ctx)
            return has_dprint_config(ctx)
          end,
        },
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
            return has_prettier_config(ctx)
          end,
          prepend_args = function(_, ctx)
            if is_effect_project(ctx) then
              return { "--ignore-path", "/dev/null" }
            end
            return {}
          end,
        },
      },
    },
  },
}

-- Unified project tool cache with TTL
local cache = {}
local CACHE_TTL = 300 * 1000 -- 5 minutes in ms (vim.uv.now() returns ms)
local MAX_CACHE = 20

-- Config file lists (extracted constants)
local EFFECT_CONFIGS = {
  "effect.config.ts",
  "effect.config.js",
  "effect.config.mjs",
  "effect.config.cjs",
}

local PRETTIER_CONFIGS = {
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
}

local DPRINT_CONFIGS = {
  "dprint.json",
  ".dprint.json",
  "dprint.jsonc",
  ".dprint.jsonc",
}

local OXFMT_CONFIGS = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
}

-- Utility: Find file upward
local function find_upward(filename, names)
  return vim.fs.find(names, {
    path = filename,
    upward = true,
    stop = vim.uv.os_homedir(),
    limit = 1,
  })[1]
end

-- Utility: Read and parse JSON
local function read_json(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()
  local ok, parsed = pcall(vim.json.decode, content)
  return ok and parsed or nil
end

-- Batch detect all project tools (single function, single pass)
local function detect_project_tools(ctx)
  local dir = vim.fn.fnamemodify(ctx.filename, ":h")
  local result = {
    has_effect = false,
    has_biome = false,
    has_dprint = false,
    has_oxfmt = false,
    has_prettier = false,
    prettier_cwd = nil,
    tailwind_plugin = nil,
    ignore_path_for_prettier = nil,
  }

  -- Fast path: Check for Effect config files (effect.config.ts/js)
  local effect_config = find_upward(ctx.filename, EFFECT_CONFIGS)
  if effect_config then
    result.has_effect = true
  end

  -- Check for dprint config (can be at any level)
  local dprint_config = find_upward(ctx.filename, DPRINT_CONFIGS)
  if dprint_config then
    result.has_dprint = true
  end

  -- Check for biome.json (can be at any level)
  local biome_json = find_upward(ctx.filename, { "biome.json", "biome.jsonc" })
  if biome_json then
    result.has_biome = true
  end

  -- Check for oxfmt config
  local oxfmt_config = find_upward(ctx.filename, OXFMT_CONFIGS)
  if oxfmt_config then
    result.has_oxfmt = true
  end

  -- Check for prettier config (can be at any level)
  local prettier_config = find_upward(ctx.filename, PRETTIER_CONFIGS)
  if prettier_config then
    result.has_prettier = true
    result.prettier_cwd = vim.fs.dirname(prettier_config)
  end

  -- Monorepo handling: Search upward through multiple package.json files
  -- Stop when we find tooling deps or hit the monorepo root (nx.json, pnpm-workspace.yaml)
  local current_dir = dir
  local home_dir = vim.uv.os_homedir()

  while current_dir and current_dir ~= home_dir do
    local package_json_path = current_dir .. "/package.json"
    local stat = vim.uv.fs_stat(package_json_path)

    if stat and stat.type == "file" then
      local pkg = read_json(package_json_path)
      if pkg then
        local deps = pkg.dependencies or {}
        local dev_deps = pkg.devDependencies or {}

        -- Effect detection (if not already found via config file)
        if not result.has_effect then
          if dev_deps["@effect/eslint-plugin"] or dev_deps["@tooling/api-eslint-config"] then
            result.has_effect = true
          end
        end

        -- Biome detection from package.json (if not already found via biome.json)
        if not result.has_biome then
          if dev_deps["@biomejs/biome"] or deps["@biomejs/biome"] then
            result.has_biome = true
          end
        end

        -- Prettier detection from package.json (if not already found via config)
        if not result.has_prettier and pkg.prettier ~= nil then
          result.has_prettier = true
          result.prettier_cwd = current_dir
        end

        -- Tailwind plugin detection (only check at root level)
        if not result.tailwind_plugin then
          if dev_deps["prettier-plugin-tailwindcss"] or deps["prettier-plugin-tailwindcss"] then
            local tailwind_path = current_dir .. "/node_modules/prettier-plugin-tailwindcss/dist/index.mjs"
            local tailwind_stat = vim.uv.fs_stat(tailwind_path)
            if tailwind_stat and tailwind_stat.type == "file" then
              result.tailwind_plugin = tailwind_path
            end
          end
        end

        -- Check if this is the monorepo root (stop searching)
        local nx_json = current_dir .. "/nx.json"
        local pnpm_workspace = current_dir .. "/pnpm-workspace.yaml"
        local nx_stat = vim.uv.fs_stat(nx_json)
        local pnpm_stat = vim.uv.fs_stat(pnpm_workspace)

        -- Stop if we found all tools we're looking for OR we hit monorepo root
        if nx_stat or pnpm_stat then
          break
        end
      end
    end

    -- Move up to parent directory
    local parent = vim.fs.dirname(current_dir)
    if parent == current_dir then
      break
    end
    current_dir = parent
  end

  -- Set ignore path for prettier in effect projects
  result.ignore_path_for_prettier = result.has_effect and "/dev/null" or nil

  result.created_at = vim.uv.now()
  return result
end

-- Cache management with LRU eviction
local function get_cached_tools(ctx)
  local dir = vim.fn.fnamemodify(ctx.filename, ":h")
  local cached = cache[dir]

  -- Cache hit and not expired
  if cached and (vim.uv.now() - cached.created_at) < CACHE_TTL then
    return cached
  end

  -- Cache miss or expired - detect and cache
  local detected = detect_project_tools(ctx)
  cache[dir] = detected

  -- LRU eviction if over limit
  local cache_count = 0
  local oldest_dir = nil
  local oldest_time = math.huge

  for k, v in pairs(cache) do
    cache_count = cache_count + 1
    if v.created_at < oldest_time then
      oldest_time = v.created_at
      oldest_dir = k
    end
  end

  if cache_count > MAX_CACHE and oldest_dir then
    cache[oldest_dir] = nil
  end

  return detected
end

-- User commands for autoformat toggle
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
        javascript = { "dprint", "oxfmt", "eslint_d", "biome", "prettierd", stop_after_first = true },
        javascriptreact = {
          "prettier_tailwind",
          "dprint",
          "oxfmt",
          "eslint_d",
          "biome",
          "prettierd",
          stop_after_first = true,
        },
        typescript = { "dprint", "oxfmt", "eslint_d", "biome", "prettierd", stop_after_first = true },
        typescriptreact = {
          "prettier_tailwind",
          "dprint",
          "oxfmt",
          "eslint_d",
          "biome",
          "prettierd",
          stop_after_first = true,
        },
        vue = { "prettier_tailwind", "biome", "oxfmt", "prettierd", stop_after_first = true },
        astro = { "prettier_tailwind", "biome", "oxfmt", "prettierd", stop_after_first = true },
        angular = { "prettier_tailwind", "biome", "oxfmt", "prettierd", stop_after_first = true },
        htmlangular = { "prettierd" },
        css = { "biome", "prettierd", stop_after_first = true },
        scss = { "prettierd" },
        less = { "prettierd" },
        html = { "prettier_tailwind", "prettierd", stop_after_first = true },
        mjml = { "prettierd" },
        json = { "biome", "oxfmt", "prettierd", stop_after_first = true },
        jsonc = { "biome", "oxfmt", "prettierd", stop_after_first = true },
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
            local tools = get_cached_tools(ctx)
            return tools.prettier_cwd
          end,
          args = { "--stdin-filepath", "$FILENAME" },
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
            local tools = get_cached_tools(ctx)
            return tools.tailwind_plugin ~= nil
          end,
        },
        dprint = {
          condition = function(_, ctx)
            local tools = get_cached_tools(ctx)
            return tools.has_dprint
          end,
        },
        eslint_d = {
          condition = function(_, ctx)
            local tools = get_cached_tools(ctx)
            return tools.has_effect
          end,
        },
        biome = {
          condition = function(_, ctx)
            local tools = get_cached_tools(ctx)
            return tools.has_biome
          end,
        },
        oxfmt = {
          command = function(self, ctx)
            return require("conform.util").from_node_modules("oxfmt")(self, ctx)
          end,
          args = { "--stdin-filepath", "$FILENAME" },
          stdin = true,
          cwd = function(self, ctx)
            return require("conform.util").root_file(OXFMT_CONFIGS)(self, ctx)
          end,
          condition = function(_, ctx)
            local tools = get_cached_tools(ctx)
            return tools.has_oxfmt
          end,
        },
        prettierd = {
          cwd = function(_, ctx)
            local tools = get_cached_tools(ctx)
            return tools.prettier_cwd
          end,
          prepend_args = function(_, ctx)
            local tools = get_cached_tools(ctx)
            if tools.ignore_path_for_prettier then
              return { "--ignore-path", tools.ignore_path_for_prettier }
            end
            return {}
          end,
        },
      },
    },
  },
}

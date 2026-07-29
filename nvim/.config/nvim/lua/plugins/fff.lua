local env_ignore_rules = {
  "# Keep local environment files searchable in FFF.",
  "!.env",
  "!.env.*",
  "!.dev.vars",
}

local function ensure_env_files_searchable()
  local ignore_path = vim.fs.joinpath(vim.fn.getcwd(), ".ignore")
  local lines = {}

  if vim.uv.fs_stat(ignore_path) then
    local ok, existing = pcall(vim.fn.readfile, ignore_path)
    if not ok then
      vim.notify("FFF could not read " .. ignore_path, vim.log.levels.WARN)
      return
    end
    lines = existing
  end

  local present = {}
  for _, line in ipairs(lines) do
    present[line] = true
  end

  local missing = {}
  for _, rule in ipairs(env_ignore_rules) do
    if not present[rule] then
      table.insert(missing, rule)
    end
  end

  if #missing == 0 then
    return
  end
  if #lines > 0 and lines[#lines] ~= "" then
    table.insert(missing, 1, "")
  end

  local ok, result = pcall(vim.fn.writefile, missing, ignore_path, "a")
  if not ok or result ~= 0 then
    vim.notify("FFF could not update " .. ignore_path, vim.log.levels.WARN)
  end
end

return {
  {
    "dmtrKovalenko/fff.nvim",
    version = "0.10.x",
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    opts = {},
    lazy = false, -- the plugin lazy-initialises itself (background index warmup)
    init = function()
      ensure_env_files_searchable()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = vim.api.nvim_create_augroup("fff_env_ignore", { clear = true }),
        callback = ensure_env_files_searchable,
        desc = "Keep environment files searchable in FFF",
      })
    end,
    keys = {
      {
        "<leader>ff",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files in project directory (fff)",
      },
      {
        "<leader>fg",
        function()
          require("fff").live_grep()
        end,
        desc = "Find by grepping in project directory (fff)",
      },
      {
        "<leader>fw",
        function()
          require("fff").live_grep({ query = vim.fn.expand("<cword>") })
        end,
        desc = "[F]ind current [W]ord (fff)",
      },
      {
        "<leader>fW",
        function()
          require("fff").live_grep({ query = vim.fn.expand("<cWORD>") })
        end,
        desc = "[F]ind current [W]ORD (fff)",
      },
      {
        "<leader>/",
        function()
          local fff = require("fff")
          local file = vim.fn.expand("%:.")
          -- unnamed or out-of-cwd buffers can't be targeted via a path constraint
          if file == "" or file:sub(1, 1) == "/" then
            fff.live_grep()
            return
          end
          fff.live_grep({ query = file .. " " })
        end,
        desc = "[/] Live grep the current file (fff)",
      },
    },
  },
}

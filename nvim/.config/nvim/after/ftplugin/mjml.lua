-- MJML filetype specific settings
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true
vim.bo.commentstring = "<!-- %s -->"

-- Use HTML tree-sitter parser for MJML files
vim.treesitter.language.register("html", "mjml")

-- Disable all formatting for MJML files
vim.b.autoformat = false

-- Disable formatting for all currently attached LSP clients
local clients = vim.lsp.get_active_clients({ bufnr = 0 })
for _, client in ipairs(clients) do
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  client.server_capabilities.documentOnTypeFormattingProvider = false
end

-- Disable formatting for any LSP clients that attach later
vim.api.nvim_create_autocmd("LspAttach", {
  buffer = 0,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.documentOnTypeFormattingProvider = false
    end
  end,
})

-- Check if we need to start our custom HTML LSP
local html_lsp_attached = false
for _, client in ipairs(clients) do
  if client.name == "html" or client.name == "html-lsp-mjml" then
    html_lsp_attached = true
    break
  end
end

-- Only start if not already attached
if not html_lsp_attached then
  vim.lsp.start({
    name = "html-lsp-mjml",
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-html-language-server"), "--stdio" },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git", "package.json" }, { upward = true })[1]),
    on_attach = function(client, bufnr)
      -- Disable formatting capabilities for MJML
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    init_options = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true,
      },
      provideFormatter = true,
    },
    settings = {
      html = {
        format = {
          templating = true,
          wrapLineLength = 120,
          unformatted = "wbr",
          indentInnerHtml = true,
        },
        validate = true,
        suggest = {
          html5 = true,
        },
        -- Custom data for MJML tags
        customData = {
          {
            version = 1.0,
            tags = {
              -- Core structure
              { name = "mjml", attributes = {} },
              { name = "mj-head", attributes = {} },
              {
                name = "mj-body",
                attributes = { { name = "background-color" }, { name = "css-class" }, { name = "width" } },
              },
              {
                name = "mj-section",
                attributes = { { name = "background-color" }, { name = "padding" }, { name = "css-class" } },
              },
              { name = "mj-column", attributes = { { name = "width" }, { name = "padding" }, { name = "css-class" } } },
              { name = "mj-group", attributes = { { name = "width" }, { name = "css-class" } } },
              {
                name = "mj-wrapper",
                attributes = { { name = "background-color" }, { name = "padding" }, { name = "css-class" } },
              },

              -- Content components
              {
                name = "mj-text",
                attributes = { { name = "color" }, { name = "font-size" }, { name = "align" }, { name = "css-class" } },
              },
              {
                name = "mj-button",
                attributes = {
                  { name = "href" },
                  { name = "background-color" },
                  { name = "color" },
                  { name = "css-class" },
                },
              },
              {
                name = "mj-image",
                attributes = { { name = "src" }, { name = "alt" }, { name = "width" }, { name = "css-class" } },
              },
              {
                name = "mj-divider",
                attributes = { { name = "border-color" }, { name = "border-width" }, { name = "css-class" } },
              },
              { name = "mj-spacer", attributes = { { name = "height" }, { name = "css-class" } } },
              { name = "mj-table", attributes = { { name = "css-class" } } },
              { name = "mj-raw", attributes = {} },

              -- Navigation
              { name = "mj-navbar", attributes = { { name = "background-color" }, { name = "css-class" } } },
              {
                name = "mj-navbar-link",
                attributes = { { name = "href" }, { name = "color" }, { name = "css-class" } },
              },

              -- Social
              { name = "mj-social", attributes = { { name = "mode" }, { name = "css-class" } } },
              {
                name = "mj-social-element",
                attributes = { { name = "href" }, { name = "name" }, { name = "css-class" } },
              },

              -- Media
              {
                name = "mj-hero",
                attributes = { { name = "background-url" }, { name = "background-color" }, { name = "css-class" } },
              },
              { name = "mj-carousel", attributes = { { name = "css-class" } } },
              {
                name = "mj-carousel-image",
                attributes = { { name = "src" }, { name = "alt" }, { name = "css-class" } },
              },

              -- Head elements
              { name = "mj-title", attributes = {} },
              { name = "mj-preview", attributes = {} },
              { name = "mj-attributes", attributes = {} },
              { name = "mj-all", attributes = {} },
              { name = "mj-class", attributes = { { name = "name" } } },
              { name = "mj-style", attributes = { { name = "inline" } } },
            },
          },
        },
      },
    },
  })
end

-- LSP keymaps for navigation
local opts = { buffer = true, silent = true }

-- LSP navigation keymaps (gd is overridden below for includes)
vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find References" }))
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
vim.keymap.set(
  "n",
  "gy",
  vim.lsp.buf.type_definition,
  vim.tbl_extend("force", opts, { desc = "Go to Type Definition" })
)
vim.keymap.set(
  "n",
  "K",
  vim.lsp.buf.hover({
    border = "single",
    max_height = 25,
    max_width = 120,
  }),
  vim.tbl_extend("force", opts, { desc = "Hover Documentation" })
)

-- MJML-specific keymaps

-- Validate MJML with better error reporting
vim.keymap.set("n", "<leader>mv", function()
  local filename = vim.fn.expand("%:p")
  local cmd = string.format('mjml --validate "%s" 2>&1', filename)
  local output = vim.fn.system(cmd)

  if vim.v.shell_error == 0 then
    vim.notify("MJML is valid!", vim.log.levels.INFO, { title = "MJML Validation" })
  else
    -- Parse validation errors and show in quickfix
    local lines = vim.split(output, "\n")
    local qf_list = {}

    for _, line in ipairs(lines) do
      if line:match("Line %d+") then
        local line_num = line:match("Line (%d+)")
        local error_msg = line:match("Line %d+: (.+)")
        if line_num and error_msg then
          table.insert(qf_list, {
            filename = filename,
            lnum = tonumber(line_num),
            col = 1,
            text = error_msg,
            type = "E",
          })
        end
      end
    end

    if #qf_list > 0 then
      vim.fn.setqflist(qf_list)
      vim.cmd("copen")
      vim.notify(
        "MJML validation errors found. Check quickfix list.",
        vim.log.levels.ERROR,
        { title = "MJML Validation" }
      )
    else
      vim.notify("MJML validation failed:\n" .. output, vim.log.levels.ERROR, { title = "MJML Validation" })
    end
  end
end, vim.tbl_extend("force", opts, { desc = "Validate MJML" }))

-- Compile MJML to HTML with better options
vim.keymap.set("n", "<leader>mc", function()
  local filename = vim.fn.expand("%:p")
  local output_file = vim.fn.expand("%:p:r") .. ".html"
  local cmd = string.format('mjml "%s" -o "%s" --config.beautify --config.minify=false', filename, output_file)

  local output = vim.fn.system(cmd)
  if vim.v.shell_error == 0 then
    vim.notify(
      "MJML compiled successfully to " .. vim.fn.fnamemodify(output_file, ":t"),
      vim.log.levels.INFO,
      { title = "MJML Compile" }
    )
  else
    vim.notify("MJML compilation failed:\n" .. output, vim.log.levels.ERROR, { title = "MJML Compile" })
  end
end, vim.tbl_extend("force", opts, { desc = "Compile MJML to HTML" }))

-- Preview HTML in browser
vim.keymap.set("n", "<leader>mp", function()
  local html_file = vim.fn.expand("%:p:r") .. ".html"
  if vim.fn.filereadable(html_file) == 1 then
    local cmd = string.format('open "%s"', html_file) -- macOS
    vim.fn.system(cmd)
  else
    print("HTML file not found. Compile MJML first with <leader>mc")
  end
end, vim.tbl_extend("force", opts, { desc = "Preview HTML in browser" }))

-- Fix template variables
vim.keymap.set("n", "<leader>mf", function()
  -- Save current view
  local view = vim.fn.winsaveview()

  -- Fix template variables with any amount of whitespace
  vim.cmd([[silent! %s/{\s*{\s*/{{/g]])
  vim.cmd([[silent! %s/\s*}\s*}/}}/g]])

  -- Restore view
  vim.fn.winrestview(view)
  print("Fixed template variables")
end, vim.tbl_extend("force", opts, { desc = "Fix MJML template variables" }))

-- Safe save for MJML files (bypasses all formatting)
vim.keymap.set("n", "<leader>w", function()
  vim.cmd("noautocmd write")
  vim.notify("Saved without formatting", vim.log.levels.INFO, { title = "MJML Save" })
end, vim.tbl_extend("force", opts, { desc = "Save MJML without formatting" }))

-- Auto-validate on save (optional)
vim.api.nvim_create_autocmd("BufWritePost", {
  buffer = 0,
  callback = function()
    -- Only validate if mjml command is available
    if vim.fn.executable("mjml") == 1 then
      vim.defer_fn(function()
        local filename = vim.fn.expand("%:p")
        local cmd = string.format('mjml --validate "%s" 2>&1', filename)
        local output = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 then
          vim.notify(
            "MJML validation failed on save. Use <leader>mv for details.",
            vim.log.levels.WARN,
            { title = "MJML Validation" }
          )
        end
      end, 100) -- Small delay to avoid interfering with save
    end
  end,
})

-- File include navigation feature (like go-to-definition)
local function find_include_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Find if we're on an mj-include tag
  local tag_start, tag_end = line:find("<mj%-include[^>]*>")
  if tag_start and col >= tag_start - 1 and col <= tag_end then
    -- Extract path from the tag
    local path = line:match("path=[\"']([^\"']+)[\"']", tag_start)
    if path then
      return path
    end
  end

  -- Check if cursor is within a string value for src/href attributes
  local patterns = {
    { attr = "src", pattern = "src%s*=%s*[\"']()[^\"']*()[\"']" },
    { attr = "href", pattern = "href%s*=%s*[\"']()[^\"']*()[\"']" },
    { attr = "path", pattern = "path%s*=%s*[\"']()[^\"']*()[\"']" },
  }

  for _, p in ipairs(patterns) do
    local pos = 1
    while true do
      local val_start, val_end = line:find(p.pattern, pos)
      if not val_start then
        break
      end

      -- Get the actual string value positions
      local _, str_start = line:find("[\"']", val_start)
      local str_end = line:find("[\"']", str_start + 1)

      if str_start and str_end and col >= str_start and col < str_end then
        local value = line:sub(str_start + 1, str_end - 1)
        -- For href, only return if it's an MJML file
        if p.attr == "href" and not value:match("%.mjml$") then
          return nil
        end
        return value
      end

      pos = val_end + 1
    end
  end

  return nil
end

local function goto_include_file()
  local include_path = find_include_at_cursor()
  if not include_path then
    -- Fallback to original behavior
    return vim.lsp.buf.definition()
  end

  -- Try different path resolutions
  local current_dir = vim.fn.expand("%:p:h")
  local root_dir = vim.fs.dirname(vim.fs.find({ ".git", "package.json" }, { upward = true })[1]) or current_dir

  local possible_paths = {
    include_path, -- Absolute path
    current_dir .. "/" .. include_path, -- Relative to current file
    root_dir .. "/" .. include_path, -- Relative to project root
    root_dir .. "/src/" .. include_path, -- Common src directory
    root_dir .. "/templates/" .. include_path, -- Common templates directory
    root_dir .. "/emails/" .. include_path, -- Common emails directory
    root_dir .. "/mjml/" .. include_path, -- Common mjml directory
  }

  for _, path in ipairs(possible_paths) do
    if vim.fn.filereadable(path) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(path))
      return
    end
  end

  vim.notify("Include file not found: " .. include_path, vim.log.levels.ERROR, { title = "MJML" })
end

-- Override go-to-definition for MJML files
vim.keymap.set("n", "gd", goto_include_file, vim.tbl_extend("force", opts, { desc = "Go to definition/include" }))
vim.keymap.set("n", "gf", goto_include_file, vim.tbl_extend("force", opts, { desc = "Go to file/include" }))
vim.keymap.set("n", "<C-]>", goto_include_file, vim.tbl_extend("force", opts, { desc = "Go to definition/include" }))


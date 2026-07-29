-- MJML filetype specific settings
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true
vim.bo.commentstring = "<!-- %s -->"

-- Use HTML tree-sitter parser for MJML files
vim.treesitter.language.register("html", "mjml")

-- Disable all formatting for MJML files
vim.b.disable_autoformat = true

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
vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({
    border = "single",
    max_height = 25,
    max_width = 120,
  })
end, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))

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

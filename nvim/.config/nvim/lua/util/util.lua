local M = {}

-- Custom root function to get the current file's directory
function M.root()
  local current_file_dir = vim.fn.expand("%:p:h")
  if current_file_dir and current_file_dir ~= "" then
    return current_file_dir
  end
  -- Fallback: Use the current working directory if no file is open
  return vim.loop.cwd()
end

-- Function to set the root directory
function M.set_root()
  local root_dir = M.root()
  if root_dir then
    vim.cmd("cd " .. vim.fn.fnameescape(root_dir))
    print("Root set to: " .. vim.fn.getcwd())
  else
    print("No file to set root for.")
  end
end

return M

-- Debug file to check fzf-lua functionality
local fzf_available, fzf = pcall(require, "fzf-lua")
print("FZF-Lua available:", fzf_available)

if fzf_available then
  print("Testing live_grep function...")
  -- Check if the live_grep function exists
  print("live_grep function exists:", type(fzf.live_grep) == "function")
  
  -- Print the current working directory
  print("Current working directory:", vim.fn.getcwd())
  
  -- Check if rg is installed and working
  local rg_check = vim.fn.system("which rg")
  print("rg command available:", #rg_check > 0)
  print("rg path:", rg_check)
end
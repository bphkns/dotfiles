local opts = { silent = true }

-- Moves selection up and down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Keep cursor centered on half-page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Keep search terms in the middle when browsing results
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Yank to clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to clipboard" })

-- Delete into the void
vim.keymap.set("n", "<leader>D", '"_d', { desc = "[D]elete into void" })

-- Don't press M (tags)
vim.keymap.set("n", "<C-m>", "<nop>", opts)

-- Don't press Q
vim.keymap.set("n", "Q", "<nop>", opts)

-- Delete all buffers except the current one and return to previous mark
vim.keymap.set("n", "<leader>bsd", "<cmd>%bd|e#|bd#<cr>|'<cr>", { desc = "Delete surrounding buffers" })

-- Add the following line to your init.lua
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true })

-- Search and replace word under cursor
vim.keymap.set(
  "n",
  "<leader>ig",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace word under cursor" }
)

-- Turn off arrow keys - force HJKL
vim.keymap.set("n", "<UP>", "<NOP>", opts)
vim.keymap.set("n", "<DOWN>", "<NOP>", opts)
vim.keymap.set("n", "<LEFT>", "<NOP>", opts)
vim.keymap.set("n", "<RIGHT>", "<NOP>", opts)

-- Display current filetype
vim.keymap.set({ "n", "t", "v", "i" }, "<C-x>", "<cmd>echo &filetype<cr>", opts)

-- Paste without yanking the replaced text
vim.keymap.set("v", "p", '"_dP', opts)

-- Go to next buffer
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", opts)

-- Go to previous buffer
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", opts)

-- Go to first buffer
vim.keymap.set("n", "<leader>bf", ":bfirst<CR>", opts)

-- Go to last buffer
vim.keymap.set("n", "<leader>bl", ":blast<CR>", opts)

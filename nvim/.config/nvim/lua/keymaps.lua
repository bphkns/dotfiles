-- Moves selection up and down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Keep cursor centered on half-page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Half-page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "Half-page up (centered)" })

-- Keep search terms in the middle when browsing results
vim.keymap.set("n", "n", "nzzzv", { silent = true, desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { silent = true, desc = "Previous search result (centered)" })

-- Yank to clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to clipboard" })

-- Delete into the void
vim.keymap.set("n", "<leader>D", '"_d', { desc = "[D]elete into void" })

-- Don't press M (tags)
vim.keymap.set("n", "<C-m>", "<nop>", { silent = true, desc = "Disabled (tags)" })

-- Don't press Q
vim.keymap.set("n", "Q", "<nop>", { silent = true, desc = "Disabled (Ex mode)" })

-- Delete all buffers except the current one and return to previous mark
vim.keymap.set("n", "<leader>bsd", "<cmd>%bd|e#|bd#<cr>|'<cr>", { desc = "Delete surrounding buffers" })

-- Delete the current buffer
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Delete current buffer" })

-- Search and replace word under cursor
vim.keymap.set(
  "n",
  "<leader>ig",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace word under cursor" }
)

-- Turn off arrow keys - force HJKL
vim.keymap.set("n", "<UP>", "<NOP>", { silent = true, desc = "Disabled (use k)" })
vim.keymap.set("n", "<DOWN>", "<NOP>", { silent = true, desc = "Disabled (use j)" })
vim.keymap.set("n", "<LEFT>", "<NOP>", { silent = true, desc = "Disabled (use h)" })
vim.keymap.set("n", "<RIGHT>", "<NOP>", { silent = true, desc = "Disabled (use l)" })

-- Display current filetype
vim.keymap.set({ "n", "t", "v", "i" }, "<C-x>", "<cmd>echo &filetype<cr>", { silent = true, desc = "Display filetype" })

-- Paste without yanking the replaced text
vim.keymap.set("v", "p", '"_dP', { silent = true, desc = "Paste without yanking" })

-- Go to next buffer
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "Next buffer" })

-- Go to previous buffer
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })

-- Go to first buffer
vim.keymap.set("n", "<leader>bf", ":bfirst<CR>", { silent = true, desc = "First buffer" })

-- Go to last buffer
vim.keymap.set("n", "<leader>bl", ":blast<CR>", { silent = true, desc = "Last buffer" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

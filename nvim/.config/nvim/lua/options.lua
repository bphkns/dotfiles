-- Enables line numbers on the left side of the editor
vim.opt.nu = true

-- Shows relative line numbers (distance from current line)
vim.opt.relativenumber = true

-- Sets the width of a tab character to 2 spaces
vim.opt.tabstop = 2

-- Makes the backspace key treat 2 spaces as a tab
vim.opt.softtabstop = 2

-- Sets the number of spaces for each indentation level
vim.opt.shiftwidth = 2

-- Converts tabs to spaces
vim.opt.expandtab = true

-- Automatically indents new lines based on code syntax
vim.opt.smartindent = true

-- Enables text wrapping for long lines
vim.opt.wrap = false

-- Shows a symbol at the beginning of wrapped lines
vim.o.showbreak = "↪ "

-- Disables creation of swap files
vim.opt.swapfile = false

-- Disables backup files
vim.opt.backup = false

-- Sets directory for persistent undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Enables persistent undo (saves undo history between sessions)
vim.opt.undofile = true

-- Enables incremental search (highlights matches as you type)
vim.opt.incsearch = true

-- Enables 24-bit RGB color in the terminal
vim.opt.termguicolors = true

-- Keeps 8 lines visible above/below cursor when scrolling
vim.opt.scrolloff = 8

-- Always shows the sign column (used by plugins for indicators)
vim.opt.signcolumn = "yes"

-- Adds '@-@' to the list of characters allowed in filenames
vim.opt.isfname:append("@-@")

-- Sets time in ms before various operations trigger (lower = more responsive)
vim.opt.updatetime = 50

-- Shows a vertical line at column 100 for code alignment
vim.opt.colorcolumn = "100"

-- Enable clipboard sync with system clipboard
vim.opt.clipboard = "unnamedplus"

-- Don't copy text deleted with 'c' command to clipboard
vim.keymap.set({ "n", "v" }, "c", '"_c', { noremap = true })

vim.opt.equalalways = false

vim.opt.list = true

-- Enable full transparency
vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NonText guibg=none")
vim.cmd("highlight Normal ctermbg=none")
vim.cmd("highlight NonText ctermbg=none")

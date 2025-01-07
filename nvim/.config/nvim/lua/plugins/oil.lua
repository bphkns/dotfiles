return {
  'stevearc/oil.nvim',
  opts = {
	view_options = {
		show_hidden = true
	}
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  keys = {
{	
	"<leader>o",
	"<cmd>Oil<CR>",
		desc = "Open oil file explorer"
  }
}
}

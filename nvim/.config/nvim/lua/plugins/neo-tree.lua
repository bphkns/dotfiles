return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  opts = {
    window = {
      position = "right",
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
    vim.keymap.set("n", "<C-e>", function()
      require("neo-tree.command").execute({
        toggle = true,
        source = "filesystem",
        dir = vim.fn.getcwd(),
        position = "right",
        reveal_file = vim.fn.expand("%:p"),
        reveal_force_cwd = true,
      })
    end, { desc = "Toggle Explorer" })
  end,
}

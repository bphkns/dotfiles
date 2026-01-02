return {
  {
    'chrisgrieser/nvim-origami',
    event = 'VeryLazy',
    opts = {
      pauseFoldsOnSearch = true,
      foldtext = { enabled = false },
      foldKeymaps = {
        setup = false,
        closeOnlyOnFirstColumn = false,
      },
    },
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    keys = {
      {
        '<leader>zR',
        function()
          vim.cmd('normal! zR')
        end,
        desc = 'Open all folds',
      },
      {
        '<leader>zM',
        function()
          vim.cmd('normal! zM')
        end,
        desc = 'Close all folds',
      },

    },
  },
}

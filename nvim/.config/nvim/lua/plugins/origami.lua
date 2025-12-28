return {
  {
    'chrisgrieser/nvim-origami',
    event = 'VeryLazy',
    opts = {},
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldtext = ''
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
          },
        },
      })
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

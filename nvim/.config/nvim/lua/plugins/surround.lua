return {
  {
    'echasnovski/mini.surround',
    version = '*',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('mini.surround').setup({
      })
    end
  },

}

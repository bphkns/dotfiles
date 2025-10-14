return {
  {
    'nvim-mini/mini.pairs',
    version = '*',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mini.pairs').setup({

        modes = { insert = true, command = true, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
      })
    end
  },
}

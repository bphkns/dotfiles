return {
  {
    "mistweaverco/bafa.nvim",
    version = "v1.11.2",
    opts = {},
    keys = {
      {
        "<leader>bb",
        function()
          require("bafa").toggle()
        end,
        desc = "Browse buffers",
      },
      {
        "<leader>bB",
        function()
          require("bafa").toggle({ with_jump_labels = true })
        end,
        desc = "Browse buffers with jump labels",
      },
    },
  },
}

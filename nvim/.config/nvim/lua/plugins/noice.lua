return {
  "folke/noice.nvim",
  opts = {
    routes = {
      filter = {
        event = "notify",
        find = "Intializing project",
      },
      opts = {
        skip = true,
      },
    },
  },
}

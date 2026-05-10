return {
  {
    "saghen/blink.indent",
    opts = {
      static = { enabled = false },
      scope = {
        enabled = true,
        only_current = true,
        char = "│",
      },
    },
    event = "VeryLazy",
  },
}

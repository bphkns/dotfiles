return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        options = {
          show_source = true,
          multiple_diag_under_cursor = true,
          multilines = true,
          show_all_diags_on_cursorline = false,
          enable_on_insert = false,
        },
      })
    end,
  },
}

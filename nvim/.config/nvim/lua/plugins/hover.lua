return {
  "lewis6991/hover.nvim",
  event = "LspAttach",
  config = function()
    require("hover").setup({
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.diagnostic")
        require("hover.providers.fold_preview")
        require("hover.providers.man")
        require("hover.providers.dictionary")
      end,
      preview_opts = {
        border = "rounded",
      },
      preview_window = false,
      title = true,
    })

    vim.keymap.set("n", "K", require("hover").hover, { desc = "Hover" })
    vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "Hover (select provider)" })
  end,
}

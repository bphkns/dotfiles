local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

return {
  {
    "kevinhwang91/nvim-ufo",
    branch = "main",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "0"

      require("ufo").setup({
        fold_virt_text_handler = handler,
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
        close_fold_kinds_for_ft = {},
        open_fold_hl_timeout = 0,
        enable_get_fold_virt_text = true,
        preview = {
          win_config = {
            winblend = 0,
          },
        },
      })

      -- Prevent folds from auto-closing
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldclose = ""

      vim.keymap.set("n", "<leader>zR", function()
        require("ufo").openAllFolds()
      end, { desc = "Open all folds" })
      vim.keymap.set("n", "<leader>zM", function()
        require("ufo").closeAllFolds()
      end, { desc = "Close all folds" })
      vim.keymap.set("n", "<leader>zr", function()
        require("ufo").openFoldsExceptKinds()
      end, { desc = "Open folds except kinds" })
      vim.keymap.set("n", "<leader>zm", function()
        require("ufo").closeFoldsWith()
      end, { desc = "Close folds with" })
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold or hover" })
    end,
  },
}

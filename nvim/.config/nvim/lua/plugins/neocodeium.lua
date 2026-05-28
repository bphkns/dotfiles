return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require("neocodeium")

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          neocodeium.clear()
        end,
      })

      neocodeium.setup({
        -- Keep NeoCodeium as the automatic inline AI completion provider.
        manual = false,
        silent = true,
        filter = function()
          local ok, blink = pcall(require, "blink.cmp")
          return not (ok and blink.is_visible())
        end,
        filetypes = {
          help = false,
          gitcommit = false,
          gitrebase = false,
          TelescopePrompt = false,
          ["dap-repl"] = false,
          ["."] = false,
        },
      })

      local function feedkey(key)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
      end

      vim.keymap.set("i", "<Tab>", function()
        if neocodeium.visible() then
          neocodeium.accept()
        else
          feedkey("<Tab>")
        end
      end, { silent = true, desc = "Accept NeoCodeium suggestion" })

      vim.keymap.set("i", "<S-Tab>", function()
        if neocodeium.visible() then
          neocodeium.accept_word()
        else
          feedkey("<S-Tab>")
        end
      end, { silent = true, desc = "Accept NeoCodeium word" })

      vim.keymap.set("i", "<A-e>", function()
        neocodeium.cycle_or_complete()
      end, { silent = true, desc = "Show/cycle NeoCodeium suggestion" })

      vim.keymap.set("i", "<A-r>", function()
        neocodeium.cycle_or_complete(-1)
      end, { silent = true, desc = "Cycle NeoCodeium suggestion back" })

      vim.keymap.set("i", "<A-c>", function()
        neocodeium.clear()
      end, { silent = true, desc = "Clear NeoCodeium suggestion" })
    end,
  },
}

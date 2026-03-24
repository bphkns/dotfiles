return {
  {
    "leonardcser/cursortab.nvim",
    lazy = false,
    build = "cd server && go build",
    config = function()
      if not vim.env.MERCURY_AI_TOKEN or vim.env.MERCURY_AI_TOKEN == "" then
        vim.notify("cursortab: MERCURY_AI_TOKEN is not set — AI completions disabled", vim.log.levels.WARN)
        return
      end

      require("cursortab").setup({
        provider = {
          type = "mercuryapi",
          api_key_env = "MERCURY_AI_TOKEN",
          model = "",
          temperature = 0.0,
          max_tokens = 512,
          top_k = 50,
          completion_timeout = 5000,
          privacy_mode = true,
        },
        keymaps = {
          accept = "<Tab>",
          partial_accept = "<S-Tab>",
          trigger = false,
        },
        ui = {
          completions = {
            addition_style = "dimmed",
            fg_opacity = 0.6,
          },
          jump = {
            symbol = "",
            text = " TAB ",
            show_distance = true,
          },
        },
        behavior = {
          idle_completion_delay = 50,
          text_change_debounce = 50,
          max_visible_lines = 12,
          enabled_modes = { "insert" },
          cursor_prediction = {
            enabled = true,
            auto_advance = true,
            proximity_threshold = 2,
          },
        },
        blink = {
          enabled = false,
        },
      })
    end,
  },
}

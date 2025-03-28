return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
    },
    opts = {
      keymaps = {
        accept_suggestion = nil,
      },
      disable_inline_completion = false,
      use_as_cmp_source = false, -- Don't use as cmp source directly
      enable_phantom_text = true, -- Enable ghost text directly
    },
  },
}

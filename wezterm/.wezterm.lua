local wezterm = require("wezterm")
local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").main
local config = wezterm.config_builder()

config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 14
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.colors = theme.colors()
return config

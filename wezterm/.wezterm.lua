local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrainsMono Nerd Font Mono", {})
config.font_size = 14
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.7
config.macos_window_background_blur = 20
return config

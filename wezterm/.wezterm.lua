local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("CaskaydiaCove Nerd Font", {
	weight = "Light",
})
config.color_scheme = "tokyodark"
config.font_size = 14
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
return config

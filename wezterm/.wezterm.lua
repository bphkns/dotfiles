local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("IosevkaTerm Nerd Font")
config.font_size = 14
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

local macchiato = {
	rosewater = "#F5B8AB",
	flamingo = "#F29D9D",
	pink = "#AD6FF7",
	mauve = "#FF8F40",
	red = "#E66767",
	maroon = "#EB788B",
	peach = "#FAB770",
	yellow = "#FACA64",
	green = "#70CF67",
	teal = "#4CD4BD",
	sky = "#61BDFF",
	sapphire = "#4BA8FA",
	blue = "#00BFFF",
	lavender = "#00BBCC",
	text = "#C1C9E6",
	subtext1 = "#A3AAC2",
	subtext0 = "#8E94AB",
	overlay2 = "#7D8296",
	overlay1 = "#676B80",
	overlay0 = "#464957",
	surface2 = "#3A3D4A",
	surface1 = "#2F313D",
	surface0 = "#1D1E29",
	base = "#0b0b12",
	mantle = "#11111a",
	crust = "#191926",
}

-- Apply the color scheme
config.colors = {
	foreground = macchiato.text,
	background = macchiato.base,
	cursor_bg = macchiato.rosewater,
	cursor_fg = macchiato.base,
	cursor_border = macchiato.rosewater,
	selection_fg = macchiato.base,
	selection_bg = macchiato.rosewater,
	scrollbar_thumb = macchiato.surface2,
	split = macchiato.overlay0,

	ansi = {
		macchiato.surface1,
		macchiato.red,
		macchiato.green,
		macchiato.yellow,
		macchiato.blue,
		macchiato.pink,
		macchiato.teal,
		macchiato.subtext1,
	},
	brights = {
		macchiato.surface2,
		macchiato.red,
		macchiato.green,
		macchiato.yellow,
		macchiato.blue,
		macchiato.pink,
		macchiato.teal,
		macchiato.subtext0,
	},
	indexed = {
		[16] = macchiato.peach,
		[17] = macchiato.rosewater,
	},

	tab_bar = {
		background = macchiato.mantle,
		active_tab = {
			bg_color = macchiato.base,
			fg_color = macchiato.lavender,
		},
		inactive_tab = {
			bg_color = macchiato.mantle,
			fg_color = macchiato.text,
		},
		inactive_tab_hover = {
			bg_color = macchiato.surface0,
			fg_color = macchiato.text,
		},
		new_tab = {
			bg_color = macchiato.surface0,
			fg_color = macchiato.text,
		},
		new_tab_hover = {
			bg_color = macchiato.surface1,
			fg_color = macchiato.text,
		},
	},
}

return config

-- Personal bindings not provided by Omarchy's Quattro defaults.

o.bind("SUPER + SHIFT + T", "Terminal", { omarchy = "terminal" })

-- Was: HEY Calendar.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Calendar", "lvsk-calendar-launcher")

-- Disable Omarchy's zoom shortcuts.
hl.unbind("SUPER + CTRL + Z")
hl.unbind("SUPER + CTRL + ALT + Z")

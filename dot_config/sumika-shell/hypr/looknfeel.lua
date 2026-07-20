-- Personal cursor theme override.
-- Loaded by hypr/hyprland.lua after the repo's hypr/looknfeel.lua.
-- Uses Adwaita instead of Hyprland's bibata waterdrop fallback.

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_THEME", "Adwaita")
o.exec_on_start("hyprctl setcursor Adwaita 24")

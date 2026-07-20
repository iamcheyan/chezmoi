-- Personal input method keybindings.
-- Loaded by hypr/hyprland.lua after the repo's hypr/bindings.lua.
-- Only needed if you use Rime schema cycling.

local paths = require("default.hypr.paths")

hl.unbind("SUPER + SPACE")
hl.unbind("SUPER + SHIFT + SPACE")
o.bind("SUPER + SPACE", "Next input language", "qs -p " .. paths.omd_root .. "/apps/omd-bar ipc call inputMethod cycle 1")
o.bind("SUPER + SHIFT + SPACE", "Previous input language", "qs -p " .. paths.omd_root .. "/apps/omd-bar ipc call inputMethod cycle -1")
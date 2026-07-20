-- Personal input method and Waybar autostart.
-- Loaded by hypr/hyprland.lua after the repo's hypr/autostart.lua.

local paths = require("default.hypr.paths")

o.launch_on_start("fcitx5 --disable notificationitem")

-- Kill Waybar if it's running (personal preference).
o.exec_on_start("mkdir -p " .. paths.state_home .. "/toggles && touch " .. paths.state_home .. "/toggles/waybar-off")
o.exec_on_start("pkill -x waybar || true")
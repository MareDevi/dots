local launcher = "vicinae"
local deeplink = launcher .. " deeplink "

return {
	terminal = "ghostty",
	browser = "google-chrome-stable",
	file_manager = "nautilus",
	launcher = launcher,
	launcher_toggle = launcher .. " toggle",
	launcher_windows = deeplink .. "'vicinae://launch/wm/switch-windows?toggle=true'",
	launcher_clipboard = deeplink .. "'vicinae://launch/clipboard/history?toggle=true'",
	launcher_emojis = deeplink .. "'vicinae://launch/core/search-emojis?toggle=true'",
	launcher_wallpapers = deeplink .. "'vicinae://launch/@sovereign/store.vicinae.awww-switcher/wpgrid?toggle=true'",
	launcher_random_wallpaper = "~/.config/hypr/scripts/wallpaper/randomize",
	main_mod = "SUPER",
}

local hs = require("plugins.hyprsplit")
local defaults = require("lua.defaults")

local main_mod = defaults.main_mod

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        numlock_by_default = true,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            scroll_factor = 1,
        },
    },
    cursor = {
        inactive_timeout = 3,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd(defaults.terminal))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(defaults.file_manager))
hl.bind(main_mod .. " + W", hl.dsp.exec_cmd(defaults.browser))
hl.bind(main_mod .. " + Tab", hl.dsp.exec_cmd(defaults.launcher_toggle))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(defaults.launcher_windows))
hl.bind(main_mod .. " + Y", hl.dsp.exec_cmd(defaults.launcher_clipboard))
hl.bind(main_mod .. " + period", hl.dsp.exec_cmd(defaults.launcher_emojis))
hl.bind(main_mod .. " + CTRL + W", hl.dsp.exec_cmd(defaults.launcher_wallpapers))
hl.bind(main_mod .. " + SHIFT + W", hl.dsp.exec_cmd(defaults.launcher_random_wallpaper))
hl.bind(
    main_mod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

hl.bind(main_mod .. " + A", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))

hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(main_mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for i = 1, 10 do
    local key = i % 10
    hl.bind(main_mod .. " + " .. key, hs.dsp.focus({ workspace = i }))
    hl.bind(main_mod .. " + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind("CTRL + " .. main_mod .. " + left", hs.dsp.focus({ workspace = "-1" }))
hl.bind("CTRL + " .. main_mod .. " + right", hs.dsp.focus({ workspace = "+1" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/audio up"), {
    locked = true,
    repeating = true,
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/audio down"), {
    locked = true,
    repeating = true,
})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/audio mute"), {
    locked = true,
    repeating = true,
})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/audio mic-mute"), {
    locked = true,
    repeating = true,
})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/brightness up"), {
    locked = true,
    repeating = true,
})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/brightness down"), {
    locked = true,
    repeating = true,
})

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/media next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/media play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/media play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("~/.config/hypr/scripts/osd/media previous"), { locked = true })

hl.bind(main_mod .. " + N", hl.dsp.exec_cmd("command -v swaync-client >/dev/null 2>&1 && swaync-client -t -sw"))

hl.bind(
    main_mod .. " + SHIFT + S",
    hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot/satty-region")
)
hl.bind(
    main_mod .. " + ALT + S",
    hl.dsp.exec_cmd('hyprshot -m region -o "$HOME/Pictures/Screenshots" -z')
)
hl.bind("Print", hl.dsp.exec_cmd('hyprshot -m window -o "$HOME/Pictures/Screenshots" -z'))
hl.bind(
    main_mod .. " + Print",
    hl.dsp.exec_cmd('hyprshot -m active -m window -o "$HOME/Pictures/Screenshots" -z')
)
hl.bind(
    main_mod .. " + SHIFT + Print",
    hl.dsp.exec_cmd('hyprshot -m output -o "$HOME/Pictures/Screenshots" -z')
)

hl.window_rule({
    name = "center-float",
    match = { class = "^(center-float)$|^(com.center-float)$" },
    float = true,
    size = { "60%", "60%" },
    center = true,
})
hl.window_rule({
    name = "center-float-title",
    match = {
        title = "^(.*Open Folder.*)$|^(.*Open File.*)$|^(.*Save File.*)$|^(.*Save Folder.*)$|^(.*Save Image.*)$|^(.*Save As.*)$|^(.*Open As.*)$",
    },
    float = true,
    size = { "60%", "60%" },
    center = true,
})
hl.window_rule({
    name = "videobridge",
    match = { class = "^(.*xwaylandvideobridge.*)$" },
    opacity = "0.0 override 0.0 override",
    no_anim = true,
    no_blur = true,
    no_initial_focus = true,
    max_size = { 1, 1 },
})
hl.window_rule({
    name = "QQ",
    match = { class = "^(.*QQ.*)$" },
    float = true,
    size = { 1248, 782 },
    center = true,
})
hl.window_rule({
    name = "fdm",
    match = { class = "^(fdm)$" },
    float = true,
    size = { 1280, 860 },
    center = true,
})
hl.window_rule({
    name = "ZenGoogleLogin",
    match = {
        title = "^(.*Sign in - Google Accounts.*)$",
        class = "^(zen)$",
    },
    float = true,
    size = { 450, 750 },
    center = true,
})
hl.window_rule({
    name = "SteamFriends",
    match = {
        class = "^(steam)$",
        title = "^(Friends List)$",
    },
    float = true,
})

hl.layer_rule({
    name = "no_anim_for_selection",
    no_anim = true,
    match = { namespace = "^(selection)$" },
})

hl.layer_rule({
    name = "vicinae-blur",
    blur = true,
    ignore_alpha = 0,
    match = { namespace = "^(vicinae)$" },
})

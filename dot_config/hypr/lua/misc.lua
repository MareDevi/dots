hl.config({
    general = {
        allow_tearing = false,
        layout = "dwindle",
    },
    misc = {
        always_follow_on_dnd = true,
        disable_hyprland_logo = true,
        vrr = 1,
        animate_manual_resizes = true,
        animate_mouse_windowdragging = false,
        enable_swallow = true,
        font_family = "Maple Mono NF",
    },
    binds = {
        movefocus_cycles_fullscreen = false,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    dwindle = {
        preserve_split = true,
        force_split = 0,
    },
})

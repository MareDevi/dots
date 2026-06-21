local hs = require("plugins.hyprsplit")

hs.config({
    num_workspaces = 10,
    persistent_workspaces = false,
})

hs.monitor_priority({ "HDMI-A-1", "eDP-1" })

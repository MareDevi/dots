#!/usr/bin/env bash

# 停止 hypridle，避免远程串流时自动锁屏/关屏
systemctl --user stop hypridle 2>/dev/null

# 恢复亮度
brightnessctl -r 2>/dev/null

# 确保屏幕打开
hyprctl dispatch 'hl.dsp.dpms({ action = "on" })'

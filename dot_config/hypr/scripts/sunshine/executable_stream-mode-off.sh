#!/usr/bin/env bash

# 恢复 hypridle
systemctl --user start hypridle 2>/dev/null

# 恢复亮度
brightnessctl -r 2>/dev/null

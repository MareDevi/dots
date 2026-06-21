#!/usr/bin/env bash

set -euo pipefail

bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

bar_length=${#bar}

for ((i = 0; i < bar_length; i++)); do
	dict+=";s/$i/${bar:$i:1}/g"
done

runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"
config_file="$runtime_dir/waybar-cava-${WAYBAR_OUTPUT_NAME:-default}.conf"

cat >"$config_file" <<EOF
[general]
bars = 16
# framerate = 120

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7

[color]
gradient = 1

gradient_color_1 = '#8bd5ca'
gradient_color_2 = '#91d7e3'
gradient_color_3 = '#7dc4e4'
gradient_color_4 = '#8aadf4'
gradient_color_5 = '#c6a0f6'
gradient_color_6 = '#f5bde6'
gradient_color_7 = '#ee99a0'
gradient_color_8 = '#ed8796'
EOF

pkill -f "cava -p $config_file" || true

stdbuf -oL cava -p "$config_file" | sed -u "$dict"

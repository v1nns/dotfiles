#!/bin/sh
# Startup applications
#
# Execute a list of applications after wayland startup

waybar &
hyprpaper &
hyprswitch init --show-title --size-factor 3 --workspaces-per-row 5 &
swayidle -w
qpwgraph &
systemctl --user start hyprpolkitagent
sleep 1 && hyprpm reload -n

# this is not good...
hyprctl plugin load /home/vinicius/.local/share/hyprpm/hy3/hy3.so

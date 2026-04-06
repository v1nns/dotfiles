#!/bin/sh
# Startup applications
#
# Execute a list of applications after wayland startup

hyprpaper &
hypridle &
qpwgraph -m &

sleep 1 && hyprpm reload -n

# workaround with xwayland applications
fcitx5 &
clipse -listen

systemctl --user start hyprpolkitagent

~/.local/bin/hyprland_handler.sh &

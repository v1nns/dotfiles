#!/bin/sh
# Startup applications
#
# Execute a list of applications after wayland startup

hyprpaper &
# hyprswitch init --show-title --size-factor 3 --workspaces-per-row 5 &
hypridle &
qpwgraph -m &

sleep 1 && hyprpm reload -n

# workaround with xwayland applications
fcitx5 &
clipse -listen

systemctl --user start hyprpolkitagent

#!/bin/sh
# Script to show any video as wallpaper (depends on having installed both xwinwrap and mpv)
[ -z "$1" ] && exit

killall xwinwrap

sleep 0.3

# --hwdec=auto-safe
xwinwrap -ov -g 1920x1080+1080+0 -- mpv -wid WID "$1" --no-osc --no-osd-bar --loop-file --player-operation-mode=cplayer --no-audio --panscan=1.0 --no-input-default-bindings &

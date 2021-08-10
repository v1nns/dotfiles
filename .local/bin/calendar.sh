#!/bin/sh

BAR_HEIGHT=20  # polybar height
BORDER_SIZE=1  # border size from your wm settings
YAD_WIDTH=222  # 222 is minimum possible value
YAD_HEIGHT=193 # 193 is minimum possible value
DATE="$(date +"%a %d %H:%M")"

case "$1" in
--popup)
    if [ "$(xdotool getwindowfocus getwindowname)" = "yad-calendar" ]; then
        exit 0
    fi

    eval "$(xdotool getmouselocation --shell)"
    eval "$(xdotool getdisplaygeometry --shell)"

    # ATTENTION: If you do use a different resolution, maybe it will be
    # necessary to change these calculations for X and Y, good luck!

    # X
    : $((pos_x = X - YAD_WIDTH / 2))

    # Y
    : $((pos_y = HEIGHT - YAD_HEIGHT - BAR_HEIGHT - BORDER_SIZE))

    GTK_THEME="Adwaita-dark" yad --calendar --undecorated --fixed --close-on-unfocus\
        --width="$YAD_WIDTH" --height="$YAD_HEIGHT" --posx="$pos_x" --posy="$pos_y" \
        --title="yad-calendar" --borders=0 --no-buttons>/dev/null &
    ;;
*)
    echo "$DATE"
    ;;
esac
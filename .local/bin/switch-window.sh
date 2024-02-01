#!/usr/bin/env bash

case $1 in
--focus) wmfocus --font "Hack Nerd Font Mono":125 --bgcolorcurrent "rgba(30, 30, 30, 0.3)" --fill --print-only | xargs xdotool windowfocus ;;
--switch) rofi -modi combi -combi-modi window -show combi -theme ~/.config/rofi/nord/switchwindow.rasi & ;;
*) echo "Invalid option" ;;
esac


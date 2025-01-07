#!/bin/sh
# Toggle dropdown
# Author: Vinicius M. Longaray
#
# Toggle visibility of dropdown terminal and resize it based on the current focused monitor

# hacky method to get cursor centered
hyprctl dispatch focusmonitor +1
hyprctl dispatch focusmonitor -1

#hyprctl dispatch resizeactive exact 55% 60%
hyprctl dispatch resizewindowpixel exact 55% 60%, title:\^\(dropdown-terminal\)\$

hyprctl dispatch togglespecialworkspace dropdown
hyprctl dispatch centerwindow

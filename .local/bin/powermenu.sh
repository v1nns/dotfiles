#!/usr/bin/env bash

# Author: Aditya Shakya
# Adapted by: Vinicius Longaray
# Github: @v1nns

dir="~/.config/rofi/tokyo"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/powermenu.rasi"

# Options
shutdown="  Shutdown"
reboot="  Restart"
lock="  Lock"
suspend="󰒲  Sleep"
logout="󰗽  Logout"

# kill any process that can get stuck on shutdown
hasta_la_vista_baby() {
  killall -s 9 /usr/bin/kdocker
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
$shutdown)
  hasta_la_vista_baby
  systemctl poweroff
  ;;
$reboot)
  hasta_la_vista_baby
  systemctl reboot
  ;;
$lock)
  if [[ -f /usr/bin/i3lock ]]; then
    i3lock
  elif [[ -f /usr/bin/betterlockscreen ]]; then
    betterlockscreen -l
  elif [[ -f /usr/bin/swaylock ]]; then
    swaylock -f
  fi
  ;;
$suspend)
  mpc -q pause
  amixer set Master mute
  systemctl suspend
  ;;
$logout)
  if [[ "$DESKTOP_SESSION" == "i3" ]]; then
    i3-msg exit
  elif [[ "$DESKTOP_SESSION" == "hyprland" ]]; then
    hyprctl dispatch exit
  fi
  ;;
esac

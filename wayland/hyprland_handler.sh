#!/bin/bash
# Hyprland handler
# Author: Vinicius M. Longaray
#
# Utility script mainly focused to watch for events from Hyprland and perform some action based on
# the given event.
#

on_window_open() {
  # local window_address=$(echo "$1" | cut -d',' -f1)
  local window_workspace=$(echo "$1" | cut -d',' -f2)
  local window_class=$(echo "$1" | cut -d',' -f3)
  local window_title=$(echo "$1" | cut -d',' -f4-)

  # Skip if workspace has a name (contains colon, e.g., "2:teste")
  if [[ "$window_workspace" == *:* ]]; then
    return
  fi

  # Custom actions here based on window_class
  case $window_class in
    google-chrome* | brave-browser*)
      hyprctl dispatch renameworkspace $window_workspace "$window_workspace:web"
      ;;
    ffplay*)
      if [[ "$window_title" == *rtsp://* ]]; then
        hyprctl dispatch renameworkspace $window_workspace "$window_workspace:camera"
      fi
      ;;
      # *)
      #     # Default action
      #     ;;
  esac
}

handle() {
  case $1 in
    openwindow*)
      # Format: openwindow>>ADDRESS,WORKSPACE,CLASS,TITLE
      on_window_open "${1#openwindow>>}"
      ;;
      # monitoraddedv2*)
      #     # uncomment this if you explicit configure which monitor waybar is using:
      #     # external_output=$(hyprctl monitors | awk '/Monitor DP-/ {print $2 }')
      #     # sed -i "s/\"output.*/\"output\": \[\"${external_output}\"\],/" ~/.config/waybar/config
      #     sleep 1
      #     killall -SIGUSR2 waybar
      #     ddcutil setvcp --bus 17 10 80
      #     ;;
      # monitorremoved*)
      #     # uncomment this if you explicit configure which monitor waybar is using:
      #     # laptop_output='"eDP-1"'
      #     # sed -i "s/\"output.*/\"output\": \[${laptop_output}\],/" ~/.config/waybar/config
      #     sleep 1
      #     killall -SIGUSR2 waybar
      #     ;;
  esac
}

main() {
  # Do not permit more than one running instance for this script
  script_name=$(basename $0)
  running_count=$(ps aux | grep -i "${script_name}" | grep -v "grep" | wc -l)
  if [ $running_count -gt 2 ]; then
    logger "Exiting: ${script_name} already running..."
    exit
  fi

  logger "${script_name} started"
  socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
}

main

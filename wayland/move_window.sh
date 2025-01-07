#!/bin/sh
# Move window
# Author: Vinicius M. Longaray
#
# Utility script for a better experience with window operations in Hyprland
#
# Usage example:
# > move_window.sh --move 3
#

# Move window to a new workspace (in other words, an empty workspace).
# Rename new workspace with name from the old one when window is the last one in old workspace
move_to_empty() {
  # Get name from old workspace and count number of windows in it
  local name="$(hyprctl activeworkspace -j | jq -r .name | cut -d ':' -f 2 -s)" local
  count_nodes="$(hyprctl activeworkspace -j | jq -r .windows)"

  hyprctl dispatch movetoworkspace empty >/dev/null

  # Only rename if old workspace name was not empty and it was the only window on it
  if [ ! -z "$name" ] && [ $count_nodes -eq 1 ]; then
    local index="$(hyprctl activeworkspace -j | jq -r .id)"
    hyprctl dispatch renameworkspace $index "$index:$name" >/dev/null
  fi
}

# Move window to specified workspace
# Rename new workspace with name from the old one when window is the last one in old workspace
move_to() {
  local new_workspace=$1
  if [ -z "$new_workspace" ]; then
    return
  fi

  # Get name from old workspace and count number of windows in it
  local name="$(hyprctl activeworkspace -j | jq -r .name | cut -d ':' -f 2 -s)"
  local count_nodes_from_old="$(hyprctl activeworkspace -j | jq -r .windows)"
  local count_nodes_from_new=$(hyprctl workspaces -j | jq -c ".[] | select(.id | contains($new_workspace))" | jq -r .windows)

  hyprctl dispatch movetoworkspace "$new_workspace" >/dev/null

  # Only rename if these 3 conditions are met:
  #  - old workspace name was not empty;
  #  - it was the only window in it;
  #  - new workspace has no window.
  if
    [ ! -z "$name" ] && [ $count_nodes_from_old -eq 1 ] && [ -z $count_nodes_from_new ]
  then
    hyprctl dispatch renameworkspace $new_workspace "$new_workspace:$name" >/dev/null
  fi
}

# Script options
case $1 in
--empty) move_to_empty ;;
--move) move_to "$2" ;;
*) echo "Invalid option" ;;
esac

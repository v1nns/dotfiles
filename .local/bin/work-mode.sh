#!/usr/bin/env bash
# Author: Vinicius M. Longaray (@v1nns)

# ---------------------------------------------------------------------------- #
#                       Move to the correct i3 workspace                       #
# ---------------------------------------------------------------------------- #

move_i3() {
  # move it between workspaces
  i3-msg '[class="'${data_ref[className]}'"] move workspace '${data_ref[workspaceId]}
  i3-msg 'workspace '${data_ref[workspaceId]}',' \
    'rename workspace to "'${data_ref[workspaceName]}'",' \
    'move workspace to output '${data_ref[outputMonitor]}
}

# ---------------------------------------------------------------------------- #
#                    Move to the correct hyprland workspace                    #
# ---------------------------------------------------------------------------- #

move_hyprland() {
  # move it between workspaces
  hyprctl dispatch movetoworkspace ${data_ref[workspaceId]}, class:'^('${data_ref[className]}')$'
  hyprctl dispatch renameworkspace ${data_ref[workspaceId]} ${data_ref[workspaceName]}
}

# ---------------------------------------------------------------------------- #
#              Open program and move it to the expected workspace              #
# ---------------------------------------------------------------------------- #

do_the_magic_with() {
  local -n data_ref=$1
  cmd="ps ax | grep ${data_ref[name]} | grep -v grep | wc -l"

  # if not running yet
  appCount=$(eval "$cmd")
  if [ "$appCount" -le "0" ]; then
    # start application detached
    (${data_ref[command]} &)
  fi

  # wait until program starts running wild
  while [ "$appCount" -le "0" ]; do
    sleep 1
    appCount=$(eval "$cmd")
  done

  # workaround for slow loading screen =(
  if [[ "${data_ref[className]}" == "teams" ]]; then
    sleep 3
  fi

  if [[ "$XDG_CURRENT_DESKTOP" == "i3" ]]; then
    move_i3 data_ref
  elif [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    move_hyprland data_ref
  else
    echo "Unsupported desktop environment: $XDG_CURRENT_DESKTOP"
    bgnotify "Unsupported desktop environment: $XDG_CURRENT_DESKTOP"
    exit 1
  fi

}

# ---------------------------------------------------------------------------- #
#                         So you did choose this one...                        #
# ---------------------------------------------------------------------------- #

choose_the_red_pill() {

    # using associative array
    declare -A data

    # for each program, define the structure like this:
    # p.s.: I'm using icon from Nerd Fonts in 'workspaceName'
    data[name]=teams
    data[command]='teams'
    data[className]='^Microsoft Teams'
    data[workspaceId]=11
    data[workspaceName]='11:teams '
    data[outputMonitor]='DP-0'

    do_the_magic_with data
}

# ---------------------------------------------------------------------------- #
#                  Confirmation about executing the work mode                  #
# ---------------------------------------------------------------------------- #

dir="~/.config/rofi/tokyo"

confirm_work_mode() {
  rofi -dmenu -i -no-fixed-num-lines -p "Enter the matrix? " -theme $dir/confirm.rasi
}

ans=$(confirm_work_mode &)
if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
  choose_the_red_pill
else
  # nah, just take the blue one
  exit 0
fi

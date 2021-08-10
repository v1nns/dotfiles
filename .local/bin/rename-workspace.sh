#!/usr/bin/env bash

# Author: Vinicius M Longaray
# Github: @v1nns

# my own path to get custom theme for rofi
dir="~/.config/rofi/nord"
rofi_command="rofi  -theme $dir/renameworkspace.rasi"

# open rofi window asking for new name
input="$($rofi_command -dmenu -lines 0 -p 'New name for this workspace:')"

# if rofi has exitted by Esc, just exit from script
[[ ${PIPESTATUS[0]} -ne 0 ]] && exit 0

# get number from current workspace
current_workspace="$(i3-msg -t get_workspaces | jq -r 'map(select(.focused))[0].num')"

# check output from rofi
if [ -z "$input" ]
then
    # $input is empty, set workspace name only with its number
    i3-msg rename workspace to "$current_workspace"
else
    # $input is NOT empty, set workspace to "<number>:$input"
    i3-msg rename workspace to "$current_workspace:$input"
fi

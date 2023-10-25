#!/usr/bin/env bash
# Author: Vinicius M Longaray
# Github: @v1nns

# custom theme for rofi
declare -r ROFI_THEME_DIR="$HOME/.config/rofi/nord"

# get info from current workspace
workspace_info="i3-msg -t get_workspaces"
eval "$workspace_info"

# filter index and name (if existing) from focused workspace
index="$($workspace_info | jq -r 'map(select(.focused))[0].num')"
name="$($workspace_info | jq -r 'map(select(.focused))[0].name' | cut -d ':' -f 2 -s | xargs)"

# format rofi command with theme argument
rofi_command="rofi -theme $ROFI_THEME_DIR/renameworkspace.rasi"

# open rofi window asking for new name
input="$($rofi_command -dmenu -lines 0 -p 'New name for this workspace:' -filter $name)"

# if rofi has exitted by Esc, just exit from script
[[ ${PIPESTATUS[0]} -ne 0 ]] && exit 0

# check output from rofi
if [ -z "$input" ]
then
    # $input is empty, set workspace name only with its number
    i3-msg rename workspace to "$index"
else
    # $input is NOT empty, set workspace to "<number>:$input"
    i3-msg rename workspace to "$index:$input"
fi

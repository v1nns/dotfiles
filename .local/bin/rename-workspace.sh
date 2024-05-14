#!/usr/bin/env bash
# Author: Vinicius M Longaray
# Github: @v1nns

# custom theme for rofi
declare -r ROFI_THEME_DIR="$HOME/.config/rofi/tokyo"

execute_rofi() {
    # format rofi command with theme argument
    local rofi_command="rofi -theme $ROFI_THEME_DIR/renameworkspace.rasi"

    # open rofi window asking for new name
    output="$($rofi_command -dmenu -lines 0 -p 'Rename workspace:' -filter $1)"

    # if rofi has exitted by Esc, just exit from script
    [[ ${PIPESTATUS[0]} -ne 0 ]] && exit 0
}

rename_workspace_i3() {
    # get info from current workspace
    local workspace_info="i3-msg -t get_workspaces"
    eval "$workspace_info"

    # filter index and name (if existing) from focused workspace
    local index="$($workspace_info | jq -r 'map(select(.focused))[0].num')"
    local name="$($workspace_info | jq -r 'map(select(.focused))[0].name' | cut -d ':' -f 2 -s | xargs)"

    execute_rofi $name

    # check output from rofi
    if [ -z $output ]
    then
        # $input is empty, set workspace name only with its number
        i3-msg rename workspace to "$index"
    else
        # $input is NOT empty, set workspace to "<number>:$output"
        i3-msg rename workspace to "$index:$output"
    fi
}

rename_workspace_hyprland() {
    # get info from current workspace
    local workspace_info="hyprctl activeworkspace"
    eval "$workspace_info"

    # filter index and name (if existing) from focused workspace
    local index="$($workspace_info | grep -oP "workspace ID \d* \(" | grep -oP "\d*")"
    local name="$($workspace_info | grep -oP "\(.*\)" | cut -d ':' -f 2 -s | rev | cut -c2- | rev)"

    execute_rofi $name

    # check output from rofi
    if [ -z $output ]
    then
        # $input is empty, set workspace name only with its number
        hyprctl dispatch renameworkspace $index "$index"
    else
        # $input is NOT empty, set workspace to "<number>:$input"
        hyprctl dispatch renameworkspace $index "$index:$output"
    fi
}

# Check which tiling manager is running
if pgrep -x i3; then
    rename_workspace_i3;
elif pgrep -x Hyprland; then
    rename_workspace_hyprland;
fi

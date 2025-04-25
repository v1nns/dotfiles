#!/usr/bin/env bash
# Author: Vinicius M Longaray
# Github: @v1nns

# custom theme for rofi
declare -r ROFI_THEME_DIR="$HOME/.config/rofi/tokyo"

execute_rofi() {
    # format rofi command with theme argument
    local rofi_command="rofi -theme $ROFI_THEME_DIR/renameworkspace.rasi"

    # open rofi window asking for new name
    output="$($rofi_command -dmenu -lines 0 -p 'Rename workspace:' -filter "'$*'")"

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
    if [ -z $output ]; then
        # $input is empty, set workspace name only with its number
        i3-msg rename workspace to "$index"
    else
        # $input is NOT empty, set workspace to "<number>:$output"
        i3-msg rename workspace to "$index:$output"
    fi
}

rename_workspace_hyprland() {
    # get info from current active window
    local window_info="hyprctl activewindow -j"
    eval "$window_info"

    # filter index and name (if existing) from focused workspace
    local index="$($window_info | jq -r .workspace.id)"
    local name="$($window_info | jq -r .workspace.name | cut -d ':' -f 2 -s | xargs)"

    # if special workspace with "dropdown" window is focused, do not rename workspace
    if [[ "$name" == "dropdown" ]]; then
        exit
    fi

    # otherwise, we have to get info from the actual workspace
    local workspace_info="hyprctl activeworkspace -j"
    eval "$workspace_info"

    index="$($workspace_info | jq -r .id)"
    name="$($workspace_info | jq -r .name | cut -d ':' -f 2 -s | xargs)"

    if [[ "$#" -eq 0 ]]; then
        execute_rofi $name
    else
        # do not rename workspace that already has a name
        if [[ -n $name ]]; then
            exit
        fi

        # remove quotes from begin and end
        local temp="${@%\"}"
        temp="${temp#\"}"
        output=$temp
    fi

    # check output from rofi
    if [ -z $output ]; then
        # $input is empty, set workspace name only with its number
        hyprctl dispatch renameworkspace $index "$index"
    else
        # $input is NOT empty, set workspace to "<number>:$input"
        hyprctl dispatch renameworkspace $index "$index:$output"
    fi
}

# Check which tiling manager is running
if pgrep -x i3; then
    rename_workspace_i3
elif pgrep -x Hyprland; then
    rename_workspace_hyprland $@
fi

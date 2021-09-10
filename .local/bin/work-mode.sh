#!/usr/bin/env bash
# Author: Vinicius M Longaray (@v1nns)

# ---------------------------------------------------------------------------- #
#              Open program and move it to the right i3 workspace              #
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
    if [[ "${data_ref[name]}" == "teams" ]]; then
        sleep 3
    fi

    # move it between workspaces
    i3-msg '[class="'${data_ref[className]}'"] move workspace '${data_ref[workspaceId]}
    i3-msg 'workspace '${data_ref[workspaceId]}',' \
        'rename workspace to "'${data_ref[workspaceName]}'",' \
        'move workspace to output '${data_ref[outputMonitor]}
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
    data[workspaceId]=2
    data[workspaceName]='2: teams'
    data[outputMonitor]='DP-0'

    do_the_magic_with data
}

# ---------------------------------------------------------------------------- #
#                  Confirmation about executing the work mode                  #
# ---------------------------------------------------------------------------- #

dir="~/.config/rofi/nord"

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

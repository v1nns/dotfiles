#!/usr/bin/env bash
# Author: Vinicius M Longaray
# Github: @v1nns

# Picker for Hyprland windows (matches workspace name, app and title).
# When nothing matches, a new workspace is created with the typed name.

# custom theme for rofi
declare -r ROFI_THEME="$HOME/.config/rofi/tokyo/switchwindow.rasi"

# workspaces 1-20 are pinned to monitors, on-demand ones start after them
declare -r FIRST_EXTRA_WORKSPACE=21

# record separator between rofi rows (each row has two lines)
declare -r ROW_SEP=$'\x1e'

list_windows() {
    # skip scratchpads and sort by focus history, leaving the focused window as
    # the last one, so the first row is always the previously focused window
    hyprctl clients -j | jq -c '
        map(select(.mapped and (.workspace.name | startswith("special:") | not)))
        | sort_by(.focusHistoryID)
        | map(select(.focusHistoryID != 0)) + map(select(.focusHistoryID == 0))'
}

format_rows() {
    jq -j --arg sep "$ROW_SEP" '
        map(
            (.title | @html) + "\n"
            + "<span size=\"small\" foreground=\"#7aa2f7\">" + (.workspace.name | @html) + "</span>"
            + "<span size=\"small\" foreground=\"#8089b3\"> · " + (.class | @html) + "</span>"
            + "\u0000icon\u001f" + (.class | ascii_downcase)
        ) | join($sep)'
}

create_workspace() {
    # drop characters that would break the Lua expression sent to hyprctl
    local name="${1//[\"\\]/}"
    [[ -z "$name" ]] && return

    # first free workspace after the ones pinned to monitors
    local id="$(hyprctl workspaces -j | jq --argjson first "$FIRST_EXTRA_WORKSPACE" \
        '[.[].id] as $used | first(range($first; $first + 100) | select(. as $i | $used | index($i) | not))')"

    hyprctl dispatch "hl.dsp.focus({ workspace = $id })" >/dev/null
    hyprctl dispatch "hl.dsp.workspace.rename({ workspace = $id, name = \"$id:$name\" })" >/dev/null
}

main() {
    local windows="$(list_windows)"

    # output is "<row index> <typed filter>", index is -1 when nothing matched
    local output
    output="$(format_rows <<<"$windows" | rofi -theme "$ROFI_THEME" -dmenu -i -p $'\uf002' \
        -sep "$ROW_SEP" -eh 2 -markup-rows -sync -format 'i f')"

    # if rofi has exitted by Esc, just exit from script
    [[ $? -ne 0 ]] && exit 0

    local index="${output%% *}"
    local filter=""
    [[ "$output" == *" "* ]] && filter="${output#* }"

    if [[ "$index" -ge 0 ]]; then
        local address="$(jq -r --argjson i "$index" '.[$i].address' <<<"$windows")"
        hyprctl dispatch "hl.dsp.focus({ window = 'address:$address' })" >/dev/null
    else
        create_workspace "$filter"
    fi
}

main

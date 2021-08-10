#!/usr/bin/env bash

dir="$HOME/.config/polybar"

launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Launch the bar, just remember "main" module is linked to main monitor
    # and "sidebar" to second monitor
    polybar -q main -c "$dir/$style/config.ini" &
    polybar -q sidebar -c "$dir/$style/config.ini" &
}

style="cosmonaut"
launch_bar

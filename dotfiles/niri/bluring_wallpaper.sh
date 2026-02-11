#!/usr/bin/env bash

# Paths
WP_DIR="$HOME/flake-rei/assets/wallpapers/3440x1440"
WP_NORMAL="$WP_DIR/blue_sky_with_thunders.jpg"
WP_BLUR="$WP_DIR/blur/blue_sky_with_thunders.jpg"

last_state=""

update_wallpaper() {
    # Get the number of focused or visible windows
    local count
    count=$(niri msg --json windows | jq '[.[] | select(.is_focused or .is_visible)] | length')
    
    local new_state
    if [ "$count" -eq 0 ]; then
        new_state="normal"
    else
        new_state="blur"
    fi

    # Only update if the state changed to avoid flickering/unnecessary calls
    if [ "$new_state" != "$last_state" ]; then
        if [ "$new_state" = "normal" ]; then
            swww img "$WP_NORMAL" --transition-type wipe --transition-duration 1
        else
            swww img "$WP_BLUR" --transition-type wipe --transition-duration 1
        fi
        last_state="$new_state"
    fi
}

# Ensure swww-daemon is running (or it will fail)
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Initial run
update_wallpaper

# Listen for events to trigger update
# This reacts to windows opening, closing, and workspace switching
niri msg event-stream | while read -r _; do
    update_wallpaper
done

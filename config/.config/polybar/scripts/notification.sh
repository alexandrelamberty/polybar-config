#!/bin/bash
# ~/.config/polybar/scripts/notification.sh
# Toggle and display notification status for Polybar
# Author: Alexandre Lamberty <mail@alexandrelamberty.com>

ICON_ON="󱇦"   # bell
ICON_OFF="󰪑"  # bell-off

get_status() {
    local status
    status=$(dunstctl is-paused 2>/dev/null)
    if [[ "$status" == "true" ]]; then
        echo "off"
    else
        echo "on"
    fi
}

send_notification() {
    local message="$1"
    # Only send notification if dunst is not paused
    if [[ "$(get_status)" == "on" ]]; then
        notify-send -u low -t 1000 "$message"
    fi
}

toggle() {
    local current
    current=$(get_status)

    if [[ "$current" == "off" ]]; then
        # Notifications are paused -> enable them
        dunstctl close-all && dunstctl history-clear
        dunstctl set-paused false
        send_notification "󰂚 Notifications enabled"
    else
        # Notifications are active -> disable them
        send_notification "󰂛 Notifications disabled"
        dunstctl history-clear
        sleep 0.5
        dunstctl set-paused true
    fi
}

print_icon() {
    local state
    state=$(get_status)
    if [[ "$state" == "on" ]]; then
        echo "%{T2}$ICON_ON"
    else
        echo "%{T2}$ICON_OFF"
    fi
}

case "$1" in
    toggle)
        toggle
        ;;
    status|*)
        print_icon
        ;;
esac

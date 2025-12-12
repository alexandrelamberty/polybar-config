#!/bin/bash
# ~/.config/polybar/scripts/i3_windows.sh
# Display the number of i3 windows (excluding "__i3" outputs)
# Author: Alexandre Lamberty <mail@alexandrelamberty.com>

windows=$(i3-msg -t get_tree | jq -r '
    .. |
    select(.type? == "output" and .name != "__i3" and .nodes? != null) |
    .nodes[] |
    select(.type? == "con" and .name == "content") |
    recurse(.nodes[], .floating_nodes[]) |
    select(.window and .name != null) |
    "\(.id) \(.name)"
' | wc -l)

echo -e "$windows"
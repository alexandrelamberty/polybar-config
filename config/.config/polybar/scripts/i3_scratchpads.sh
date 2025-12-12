#!/bin/bash
# ~/.config/polybar/scripts/i3_scratchpads.sh
# Display the number of i3 scratchpads
# Author: Alexandre Lamberty <mail@alexandrelamberty.com>

scratchpads=$(i3-msg -t get_tree | jq -r '
    .. | 
    select(.type? == "workspace" and .name == "__i3_scratch") | 
    .floating_nodes[] |
    .nodes[] |
    select(.type == "con") |
    "\(.id) \(.name)"
' | wc -l)

echo -e "$scratchpads"
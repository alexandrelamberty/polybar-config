#!/bin/bash
# ~/.config/polybar/scripts/docker_processe.sh
# Display the number of Docker container running
# Author: Alexandre Lamberty <mail@alexandrelamberty.com>

containers=$(docker ps | wc -l)
# Remove one line for the header from the docker ps command
echo -e $((containers-1)) # -1 to remove the header 

#!/bin/bash
# Display the number of running Docker containers.

command -v docker >/dev/null 2>&1 || exit 0
docker ps --quiet 2>/dev/null | wc -l

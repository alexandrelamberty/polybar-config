#!/bin/bash
# Display the number of APT updates.

apt list --upgradable 2>/dev/null | tail -n +2 | wc -l

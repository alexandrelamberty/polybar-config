#!/usr/bin/env bash
# ~/.config/polybar/setup.sh
# Script to setup Polybar

# Terminate already running bar instances
killall -q polybar

# Output file
OUTPUT_FILE="hardware.conf.test"

# Detect wireless interface
wlan=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')

# Detect Ethernet interface
eth=$(ip -o link show | awk -F': ' '/state UP/ && $2 !~ /lo|docker|virbr|vnet|tun/{print $2}' | head -n 1)

# Detect battery
battery=$(ls /sys/class/power_supply/ | grep -m 1 BAT)

# Detect battery adapter (AC power)
battery_adapter=$(ls /sys/class/power_supply/ | grep -m 1 AC)

# Detect hwmon path for CPU temperature
hwmon_path=$(find /sys/devices/platform -type f -name "temp1_input" | head -n 1)

# Create configuration
{
  echo "[hardware]"
  echo "wlan = ${wlan:-none}"
  echo "eth = ${eth:-none}"
  echo "battery = ${battery:-none}"
  echo "battery-adapter = ${battery_adapter:-none}"
  echo "hwmon-path = ${hwmon_path:-none}"
} > "$OUTPUT_FILE"

# Notify user
echo "Hardware configuration saved to $OUTPUT_FILE"

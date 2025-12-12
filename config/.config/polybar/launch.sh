#!/usr/bin/env bash
# ~/.config/polybar/launch.sh
# Small helper to restart Polybar safely.

set -euo pipefail

if ! command -v polybar >/dev/null 2>&1; then
  echo "polybar binary not found in PATH" >&2
  exit 1
fi

killall -q polybar || true

while pgrep -u "$UID" -x polybar >/dev/null; do
  sleep 1
done

DEFAULT_IFACE=$(ip route | awk '/default/ {print $5; exit}')
export DEFAULT_IFACE

polybar top -r &
polybar bottom -r &

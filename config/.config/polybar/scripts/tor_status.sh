#!/usr/bin/env bash
# ~/.config/polybar/scripts/tor_status.sh
# Displays whether the Tor daemon is up and gives a quick visual hint for Polybar.

set -euo pipefail

TOR_SERVICES=${TOR_SERVICES:-"tor tor@default tor@default.service"}
TOR_PROCESSES=${TOR_PROCESSES:-"tor tor.real"}
TOR_ICON=${TOR_ICON:-"󰕥"}
TOR_COLOR_ON=${TOR_COLOR_ON:-"#8ec07c"}
TOR_COLOR_OFF=${TOR_COLOR_OFF:-"#fb4934"}
TOR_LABEL_ON=${TOR_LABEL_ON:-"tor"}
TOR_LABEL_OFF=${TOR_LABEL_OFF:-"off"}

is_tor_active() {
  if command -v systemctl >/dev/null 2>&1; then
    for service in $TOR_SERVICES; do
      systemctl is-active --quiet "$service" && return 0
    done
  fi

  for process in $TOR_PROCESSES; do
    if pgrep -x "$process" >/dev/null 2>&1; then
      return 0
    fi
  done

  return 1
}

if is_tor_active; then
  echo "%{F${TOR_COLOR_ON}}%{T2}${TOR_ICON}%{T-} ${TOR_LABEL_ON}%{F-}"
else
  echo "%{F${TOR_COLOR_OFF}}%{T2}${TOR_ICON}%{T-} ${TOR_LABEL_OFF}%{F-}"
fi

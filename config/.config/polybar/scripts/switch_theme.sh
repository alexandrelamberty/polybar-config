#!/usr/bin/env bash
# ~/.config/polybar/scripts/switch_theme.sh
# Toggles between the configured light/dark Polybar themes.

set -euo pipefail

CONFIG_FILE=${POLYBAR_CONFIG_FILE:-"$HOME/.config/polybar/config.ini"}
LIGHT_THEME=${POLYBAR_LIGHT_THEME:-"$HOME/.config/polybar/themes/light.ini"}
DARK_THEME=${POLYBAR_DARK_THEME:-"$HOME/.config/polybar/themes/dark.ini"}
LIGHT_ICON=${POLYBAR_LIGHT_ICON:-"󰔢"}
DARK_ICON=${POLYBAR_DARK_ICON:-"󰔡"}

[[ -f "$CONFIG_FILE" ]] || { echo "Polybar config not found: $CONFIG_FILE" >&2; exit 1; }

current_theme=$(grep -m 1 "^include-file = .*/themes/.*\\.ini" "$CONFIG_FILE" | awk -F' = ' '{print $2}')
current_theme=${current_theme:-$DARK_THEME}
current_theme=${current_theme/#\~/$HOME}

print_mode() {
  if [[ "$current_theme" == "$LIGHT_THEME" ]]; then
    echo "%{T2}$LIGHT_ICON%{T-}"
  else
    echo "%{T2}$DARK_ICON%{T-}"
  fi
}

if [[ $# -eq 0 ]]; then
  print_mode
  exit 0
fi

if [[ "$current_theme" == "$LIGHT_THEME" ]]; then
  new_theme=$DARK_THEME
else
  new_theme=$LIGHT_THEME
fi

new_theme_line=${new_theme/#$HOME/~}

tmp_file=$(mktemp)
awk -v new_theme="$new_theme_line" '
  BEGIN { replaced = 0 }
  /^include-file = .*themes\/.*\.ini$/ && !replaced {
    print "include-file = " new_theme
    replaced = 1
    next
  }
  { print }
' "$CONFIG_FILE" > "$tmp_file"
mv "$tmp_file" "$CONFIG_FILE"

if command -v polybar-msg >/dev/null 2>&1; then
  polybar-msg cmd restart >/dev/null 2>&1 || true
fi

print_mode

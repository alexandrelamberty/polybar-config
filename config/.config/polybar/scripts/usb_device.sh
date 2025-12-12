#!/usr/bin/env bash
# ~/.config/polybar/scripts/usb_device.sh
# Watches removable USB block devices and reports their status to Polybar.

set -euo pipefail

USB_POLL_INTERVAL=${USB_POLL_INTERVAL:-5}
USB_COLOR_PRESENT=${USB_COLOR_PRESENT:-"#8ec07c"}
USB_COLOR_ABSENT=${USB_COLOR_ABSENT:-"#fb4934"}

trim() {
  local value=$1
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

list_usb_storage() {
  lsblk -rpo NAME,TYPE,RM,SIZE,MODEL,TRAN -P 2>/dev/null | while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    eval "$line"
    if [[ "${TYPE:-}" == "disk" && "${RM:-}" == "1" && "${TRAN:-}" == "usb" ]]; then
      local model size
      model=$(trim "${MODEL:-$NAME}")
      size=$(trim "${SIZE:-}")
      if [[ -n "$size" ]]; then
        echo "${model} (${size})"
      else
        echo "${model}"
      fi
    fi
  done
}

render_status() {
  mapfile -t devices < <(list_usb_storage || true)
  local count=${#devices[@]}
  if (( count == 0 )); then
    echo "%{F${USB_COLOR_ABSENT}}no usb%{F-}"
    return
  fi

  local summary="${devices[0]}"
  if (( count > 1 )); then
    summary+=" +$((count-1))"
  fi

  echo "%{F${USB_COLOR_PRESENT}}${summary}%{F-}"
}

if [[ "${1:-}" == "--once" ]]; then
  render_status
  exit 0
fi

last_output=""
while true; do
  current_output=$(render_status)
  if [[ "$current_output" != "$last_output" ]]; then
    echo "$current_output"
    last_output="$current_output"
  fi
  sleep "$USB_POLL_INTERVAL"
done

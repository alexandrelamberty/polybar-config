#!/usr/bin/env bash
# ~/.config/polybar/scripts/vpn_status.sh
# Detects whether a VPN tunnel is active (NetworkManager, WireGuard, OpenVPN, ...)
# and prints a status snippet for Polybar.

set -euo pipefail

VPN_ICON=${VPN_ICON:-"󰒄"}
VPN_COLOR_ON=${VPN_COLOR_ON:-"#8ec07c"}
VPN_COLOR_OFF=${VPN_COLOR_OFF:-"#fb4934"}
VPN_LABEL_ON=${VPN_LABEL_ON:-"vpn"}
VPN_LABEL_OFF=${VPN_LABEL_OFF:-"down"}
VPN_INTERFACE_PATTERN=${VPN_INTERFACE_PATTERN:-"(wg|tun|vpn)"}
VPN_PROCESSES=${VPN_PROCESSES:-"openvpn wireguard-go wg-quick tailscaled tailscale openconnect protonvpn nordvpn expressvpn"}

nmcli_vpn_active() {
  command -v nmcli >/dev/null 2>&1 || return 1
  nmcli -t -f TYPE connection show --active 2>/dev/null | grep -qx "vpn"
}

vpn_interface_present() {
  ip -o link show up 2>/dev/null | awk -F': ' '{print $2}' | grep -Eq "$VPN_INTERFACE_PATTERN"
}

vpn_process_running() {
  for process in $VPN_PROCESSES; do
    if pgrep -x "$process" >/dev/null 2>&1; then
      return 0
    fi
  done
  return 1
}

if nmcli_vpn_active || vpn_interface_present || vpn_process_running; then
  echo "%{F${VPN_COLOR_ON}}%{T2}${VPN_ICON}%{T-} ${VPN_LABEL_ON}%{F-}"
else
  echo "%{F${VPN_COLOR_OFF}}%{T2}${VPN_ICON}%{T-} ${VPN_LABEL_OFF}%{F-}"
fi

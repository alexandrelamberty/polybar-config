# Polybar configuration

Opinionated Polybar setup that ships a curated set of internal and custom
modules. The configuration is organised so it can be easily installed on a new
machine with `stow` and tweaked via `hardware.conf` and theme files.

## Features

- Dual-bar layout with consistent fonts, padding and Nerd Font icons.
- Auto-generated hardware configuration via `setup.sh`.
- Scripted modules for Tor/VPN status, USB storage detection, tmux, scratchpads,
  updates and theming.
- Toggle between `themes/light.ini` and `themes/dark.ini` directly from Polybar.
- Helper scripts (`launch.sh`, `setup.sh`, `install.sh`) to bootstrap or reload
  the bar safely.

## Requirements

- Polybar and a Nerd Font (default: Iosevka Nerd Font Mono).
- GNU stow (used by `install.sh`).
- Optional runtimes used by the scripts: `bash`, `ip`, `nmcli`, `lsblk`,
  `polybar-msg`.

## Installation

1. Review or generate the hardware configuration:
   ```bash
   cd config/polybar
   ./config/.config/polybar/setup.sh   # writes hardware.conf.test
   ```
   Copy the resulting values into `config/.config/polybar/hardware.conf`.
2. Install the configuration into `~/.config/polybar` with stow:
   ```bash
   ./install.sh
   ```
3. Launch the bar (usually from your WM/DE autostart) using
   `~/.config/polybar/launch.sh`.

## Custom scripts overview

- `switch_theme.sh` / `toggle_theme_mode.sh` – prints the current light/dark icon
  and toggles the include-file inside `config.ini`. Uses absolute paths so the
  theme swap is reliable.
- `tor_status.sh` and `vpn_status.sh` – check for running services/processes and
  print coloured status blocks (`󰕥 tor` / `󰒄 vpn`) so you immediately know when a
  secure connection is active.
- `usb_device.sh` – polls `lsblk` and streams tail-friendly updates that show the
  first detected USB storage label plus a counter of additional devices.
- `launch.sh` – restarts Polybar safely, exporting `DEFAULT_IFACE` so network
  modules can reuse the detected default interface.

Each script accepts a few environment variables (documented at the top of the
file) so you can tweak colours, icons or polling intervals without editing the
code.

## Layout/modules

Refer to `config/.config/polybar/modules/internal/modules.ini` and
`config/.config/polybar/modules/custom/modules.ini` for the enabled modules.
Notable custom entries include Belgian heating oil price tracking, Docker/Chrome
process monitors, tmux status, USB watcher, Tor/VPN indicators and a theme
switch widget.

## References

- <https://github.com/polybar/polybar>
- <https://github.com/polybar/polybar/wiki/>

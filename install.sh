#!/bin/bash
# Polybar configuration installation

PACKAGES=(config bin)
TARGET=$HOME
DIR="$(dirname "$0")"

printf "Polybar configuration installation\n"

stow -d "$DIR" -vDt "$TARGET" "${PACKAGES[@]}"
rm -rf "$HOME/.config/polybar/"
stow -d "$DIR" -vSt "$TARGET" "${PACKAGES[@]}"


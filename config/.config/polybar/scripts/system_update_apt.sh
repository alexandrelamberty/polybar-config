#!/usr/bin/env bash

declare -r myname='checkupdates-debian'
declare -r myver='1.0.0'

# Color definitions
unset ALL_OFF BOLD BLUE GREEN RED YELLOW
if [[ -t 2 && ! $USE_COLOR = "n" ]]; then
  if tput setaf 0 &>/dev/null; then
    ALL_OFF="$(tput sgr0)"
    BOLD="$(tput bold)"
    BLUE="${BOLD}$(tput setaf 4)"
    GREEN="${BOLD}$(tput setaf 2)"
    RED="${BOLD}$(tput setaf 1)"
    YELLOW="${BOLD}$(tput setaf 3)"
  else
    ALL_OFF="\e[1;0m"
    BOLD="\e[1;1m"
    BLUE="${BOLD}\e[1;34m"
    GREEN="${BOLD}\e[1;32m"
    RED="${BOLD}\e[1;31m"
    YELLOW="${BOLD}\e[1;33m"
  fi
fi
readonly ALL_OFF BOLD BLUE GREEN RED YELLOW

plain() { (( QUIET )) && return; printf "${BOLD}    $1${ALL_OFF}\n"; }
msg() { (( QUIET )) && return; printf "${GREEN}==>${ALL_OFF}${BOLD} $1${ALL_OFF}\n"; }
error() { printf "${RED}==> ERROR:${ALL_OFF}${BOLD} $1${ALL_OFF}\n" >&2; }

if (( $# > 0 )); then
  echo "${myname} v${myver}"
  echo
  echo "Safely print a list of pending updates for Debian-based systems."
  echo
  echo "Usage: ${myname}"
  exit 0
fi

if ! command -v apt-get >/dev/null; then
  error "apt-get is not installed or not in PATH."
  exit 1
fi

if ! command -v fakeroot >/dev/null; then
  error "fakeroot is not installed or not in PATH."
  exit 1
fi

# Temporary directory for apt lists
CHECKUPDATES_DB="${TMPDIR:-/tmp}/checkupdates-db-${USER}/"
trap 'rm -rf "$CHECKUPDATES_DB"' EXIT

mkdir -p "$CHECKUPDATES_DB/var/lib/apt/lists"
mkdir -p "$CHECKUPDATES_DB/var/cache/apt/archives"

msg "Refreshing package database (this may take a moment)..."
if ! fakeroot apt-get update -o Dir::State::Lists="$CHECKUPDATES_DB/var/lib/apt/lists" \
    -o Dir::Cache::Archives="$CHECKUPDATES_DB/var/cache/apt/archives" &>/dev/null; then
  error "Failed to fetch updates."
  exit 1
fi

msg "Checking for updates..."
UPDATES=$(fakeroot apt-get -s dist-upgrade -o Dir::State::Lists="$CHECKUPDATES_DB/var/lib/apt/lists" \
    -o Dir::Cache::Archives="$CHECKUPDATES_DB/var/cache/apt/archives" \
    | grep "^Inst" | awk '{print $2 " (" $3 " -> " $4 ")"}')

if [[ -z "$UPDATES" ]]; then
  plain "Your system is up to date."
else
  echo "$UPDATES"
fi

exit 0
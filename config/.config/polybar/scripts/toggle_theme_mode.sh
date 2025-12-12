#!/usr/bin/env bash
# Compatibility wrapper kept for existing bindings. All logic now lives in
# switch_theme.sh so we simply forward the call.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
exec "$SCRIPT_DIR/switch_theme.sh" "$@"

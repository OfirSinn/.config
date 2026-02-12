#!/usr/bin/env bash
# rofi mode: system-apps (no icons)
# Usage: rofi -show apps -modi "apps:~/.config/rofi/scripts/system-apps.sh"

set -euo pipefail

# ────────────────────────────────────────────────
# Entries – name → command
# ────────────────────────────────────────────────
declare -A apps
apps=(
    ["Sound"]="pavucontrol"
    ["Bluetooth"]="kitty --class=menu.tui -e bluetui"
    ["Clock / Timer"]="kitty --class=menu.tui -e timr"
    ["Network / wifi"]="kitty --class=menu.tui -e impala"
    # Add more entries here if needed, example:
    # ["Calculator"]="rofi-calc"
)

# ────────────────────────────────────────────────
# List mode (rofi asks for entries)
# ────────────────────────────────────────────────
if [[ ${ROFI_RETV:-0} -eq 0 ]]; then
    for name in "${!apps[@]}"; do
        echo "$name"
    done
    exit 0
fi

# ────────────────────────────────────────────────
# Selection mode (user picked one)
# ────────────────────────────────────────────────
if [[ ${ROFI_RETV:-0} -eq 1 ]]; then
    selected="$1"

    if [[ -n "${apps[$selected]:-}" ]]; then
        cmd="${apps[$selected]}"
        # Launch detached / background
        setsid bash -c "$cmd" >/dev/null 2>&1 &
        exit 0
    else
        echo "No command found for: $selected" >&2
        exit 1
    fi
fi

exit 1

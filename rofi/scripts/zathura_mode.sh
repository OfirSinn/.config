#!/usr/bin/env bash
# ~/.config/rofi/scripts/zathura-cd.sh
# Run with: rofi -show zathura-cd -modi "zathura-cd:$HOME/.config/rofi/scripts/zathura-cd.sh"

set -euo pipefail

CACHE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/zathura_cd_list.txt"
# Or keep your original: CACHE_FILE=~/.config/rofi/scripts/zathura_cd_list.txt

if [[ ! -f "$CACHE_FILE" ]]; then
    echo "Cache file not found: $CACHE_FILE" >&2
    exit 1
fi

# ────────────────────────────────────────────────
# List mode (rofi calls script with no args → ROFI_RETV=0)
# ────────────────────────────────────────────────
if [[ ${ROFI_RETV:-0} -eq 0 ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue
        dir="${line%/}"           # remove trailing slash if any
        basename "$dir"
    done < "$CACHE_FILE"
    exit 0
fi

# ────────────────────────────────────────────────
# Selection mode (user picked something → ROFI_RETV=1, $1 = selected basename)
# ────────────────────────────────────────────────
if [[ ${ROFI_RETV:-0} -eq 1 ]]; then
    selected="$1"

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue
        dir="${line%/}"
        if [[ "$(basename "$dir")" == "$selected" ]]; then
            # Expand ~ if present
            target="${dir/\~/$HOME}"

            if [[ ! -d "$target" ]]; then
                echo "Directory does not exist: $target" >&2
                exit 1
            fi

            cd -- "$target" || {
                echo "Failed to cd to $target" >&2
                exit 1
            }

            # Launch zathura detached
            setsid zathura >/dev/null 2>&1 &
            # or: nohup zathura >/dev/null 2>&1 &
            # or: zathura & disown   (but setsid is cleaner in many cases)

            exit 0
        fi
    done < "$CACHE_FILE"

    # Should not reach here
    echo "No match for: $selected" >&2
    exit 1
fi

# Fallback / unknown state
exit 1

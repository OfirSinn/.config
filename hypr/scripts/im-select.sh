#!/bin/bash

# Hyprland-compatible im-select

# kbd=$(hyprctl devices -j | jq -r '.keyboards[7].active_keymap')

if [ -z "$1" ]; then
    # Just print the currently active keymap name
	hyprctl devices -j | jq -r '.keyboards[7] | .active_keymap'
	exit 0
fi

# Set layout by name instead of hardcoding index
case "$1" in
	"English (US)")
	hyprctl switchxkblayout current 0
    ;;
  "Hebrew")
	hyprctl switchxkblayout current 1
    ;;
  "German")
	hyprctl switchxkblayout current 2
    ;;
  *)
    echo "Unknown layout: $1" >&2
    exit 1
    ;;
esac


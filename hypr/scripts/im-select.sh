#!/bin/bash

kbd1="kbdcraft-adam0110"
kbd2="at-translated-set-2-keyboard"

connected_keyboards=$(hyprctl devices -j | jq -r '.keyboards[].name')

# Determine which keyboard to use for reporting or switching
if grep -Fxq "$kbd1" <<< "$connected_keyboards"; then
  selected_kbd="$kbd1"
elif grep -Fxq "$kbd2" <<< "$connected_keyboards"; then
  selected_kbd="$kbd2"
else
  echo "No valid keyboard detected." >&2
  exit 1
fi

if [ -z "$1" ]; then
  # Print only the active layout of the selected keyboard
  hyprctl devices -j | jq -r --arg kbd "$selected_kbd" '.keyboards[] | select(.name==$kbd) | .active_keymap'
  exit 0
fi

# Layout map (update as needed)
declare -A layouts=(
  ["English (US)"]=0
  ["Hebrew"]=1
  ["German"]=2
)

layout_index="${layouts[$1]}"
if [ -z "$layout_index" ]; then
  echo "Unknown layout: $1" >&2
  exit 1
fi

# Switch layout for current input device
hyprctl switchxkblayout current "$layout_index"

#!/bin/bash

# Get current gaps_in value (output format: "general:gaps_in = 5")
current_gaps_in=$(hyprctl getoption general:gaps_in | grep -oP '\d+' | head -1)

if [ "$current_gaps_in" = "4" ]; then
    # Shrink to small gaps (0)
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
else
    # Restore defaults
    hyprctl keyword general:gaps_in 4
    hyprctl keyword general:gaps_out 8
fi

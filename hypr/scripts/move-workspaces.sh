#!/bin/bash

TARGET_MONITOR=$1
start_num=$2
end_num=$3

for ws in $(seq $start_num $end_num); do
    hyprctl dispatch workspace "$ws"    
    hyprctl dispatch moveworkspacetomonitor "$ws" "$TARGET_MONITOR"
done

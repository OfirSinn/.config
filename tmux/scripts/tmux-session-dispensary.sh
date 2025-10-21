#!/bin/bash

DIRS=(
    "$HOME/repos/"
    "$HOME/.config/"
    "$HOME/Documents/Snakes_sce/"
    "$HOME"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "${DIRS[@]}" -maxdepth 1 -type d \
        | sed "s|^$HOME/||" \
        | sk --margin 10% --color="bw")

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if [[ -z $TMUX ]] && ! tmux has-session 2>/dev/null; then
    tmux start-server
fi

if ! tmux has-session -t "$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name" 2> /dev/null || tmux attach -t "$selected_name"

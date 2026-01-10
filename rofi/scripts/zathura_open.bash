#!/bin/bash

input_file=~/.config/rofi/scripts/zathura_cd_list.txt

declare -A path_dict

while IFS= read -r full_path; do
    if [ -n "$full_path" ]; then
        base_name=$(basename "$full_path")
        path_dict["$base_name"]="$full_path"
    fi
done < "$input_file"

selection=$(printf '%s\n' "${!path_dict[@]}" | rofi -dmenu -i -p "Select directory:")

if [ -z "$selection" ]; then
    exit 1
fi

full_path="${path_dict[$selection]/\~/$HOME}"
cd "${full_path}"
zathura & disown
exit 0


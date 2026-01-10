#!/bin/sh

chosen=$(cat ~/.config/rofi/scripts/zathura_cd_list.txt | rofi -dmenu)

if ["$chosen" = ""]; then exit 1
cd "$chosen"
zathura & disown
exit 0


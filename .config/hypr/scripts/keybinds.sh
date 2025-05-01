#!/bin/bash
# Searchable enabled keybinds using Rofi

# check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# define the config files
hyprland_conf="$HOME/.config/hypr/hyprland.conf"
keybinds_conf="$HOME/.config/hypr/modules/keybinds.conf"
media_conf="$HOME/.config/hypr/modules/media-binds.conf"
rofi_theme="$HOME/.config/hypr/rofi/config-keybinds.rasi"
msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO effect'

# combine the contents of the keybinds files and filter for keybinds
keybinds=$(cat "$hyprland_conf" "$keybinds_conf" "$media_conf" | grep -oP '(?<=bind = ).*')
keybinds=$(echo "$keybinds" | sed 's/,\([^,]*\)$/ =\1/' | sed 's/, exec//g' | sed 's/^,//g')
keybinds=$(echo "$keybinds" | sed 's/\t\+//g')

# check for any keybinds to display
if [[ -z "$keybinds" ]]; then
   echo "No keybinds found."
    exit 1
fi

# replace $mainmod with super in the displayed keybinds for rofi
display_keybinds=$(echo "$keybinds" | sed 's/\$mainMod/SUPER/g')

# use rofi to display the keybinds with the modified content
echo "$display_keybinds" | rofi -dmenu -i -config "$rofi_theme" -mesg "$msg"

#!/bin/bash
#  _____ _                           ______        ____        ____        __
# |_   _| |__   ___ _ __ ___   ___  / ___\ \      / /\ \      / /\ \      / /
#   | | | '_ \ / _ \ '_ ` _ \ / _ \ \___ \\ \ /\ / /  \ \ /\ / /  \ \ /\ / /
#   | | | | | |  __/ | | | | |  __/  ___) |\ V  V /    \ V  V /    \ V  V /
#   |_| |_| |_|\___|_| |_| |_|\___| |____/  \_/\_/      \_/\_/      \_/\_/
#
#
# by Stephan Raabe (2023)
# -----------------------------------------------------

# -----------------------------------------------------
# Select random wallpaper and create color scheme
# -----------------------------------------------------
wal -q -i ~/Pictures/wallpapers/

# -----------------------------------------------------
# Load current pywal color scheme
# -----------------------------------------------------
source "$HOME/.cache/wal/colors.sh"

# -----------------------------------------------------
# Copy color file to waybar folder
# -----------------------------------------------------
cp ~/.cache/wal/colors-waybar.css ~/.config/hypr/waybar/

# -----------------------------------------------------
# get wallpaper iamge name
# -----------------------------------------------------
newwall=$(echo $wallpaper | sed "s|$HOME/wallpaper/||g")

# -----------------------------------------------------
# Set the new wallpaper
# -----------------------------------------------------
swww img $wallpaper --transition-step 20 --transition-fps=20
~/.config/hypr/waybar/reload.sh

# -----------------------------------------------------
# Send notification
# -----------------------------------------------------
notify-send "Theme and Wallpaper updated" "With image $newwall"

echo "DONE!"

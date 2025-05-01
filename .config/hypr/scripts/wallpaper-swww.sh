#!/bin/bash
# __        __    _ _
# \ \      / /_ _| | |_ __   __ _ _ __   ___ _ __
#  \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
#   \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
#    \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
#                    |_|         |_|
#
# by Stephan Raabe (2023)
# -----------------------------------------------------

# -----------------------------------------------------
# Select wallpaper
# -----------------------------------------------------
# selected=$(ls -1 ~/Pictures/wallpapers | grep "jpg" | rofi -dmenu -p "Wallpapers")
selected=$(ls -1 ~/Pictures/wallpapers | rofi -dmenu -p "Wallpapers")

if [ "$selected" ]; then

	echo "Changing theme..."
	# -----------------------------------------------------
	# Update wallpaper with pywal
	# -----------------------------------------------------
	wal -q -i ~/Pictures/wallpapers/$selected

	# -----------------------------------------------------
	# Get new theme
	# -----------------------------------------------------
	source "$HOME/.cache/wal/colors.sh"

	# -----------------------------------------------------
	# Copy color file to waybar folder
	# -----------------------------------------------------
	cp ~/.cache/wal/colors-waybar.css ~/.config/hypr/waybar/

	# newwall=$(echo $wallpaper | sed "s|$HOME/wallpaper/||g")
	newwall=$(echo $selected | sed "s|$HOME/Pictures/wallpapers||g")

	# -----------------------------------------------------
	# Set the new wallpaper
	# -----------------------------------------------------
	# swww img $wallpaper --transition-step 20 --transition-fps=20
	swww img $selected --transition-step 20 --transition-fps=30 --transition-type any --transition-duration 3
	~/.config/hypr/scripts/statusbar

	# -----------------------------------------------------
	# Send notification
	# -----------------------------------------------------
	notify-send "Theme and Wallpaper updated" "With image $newwall"

	echo "Done."
fi

#!/usr/bin/env bash
album_art=$(playerctl -p spotify metadata mpris:artUrl)
if [[ -z $album_art ]]; then
	# Spotify is dead, we should die too!
	exit
fi
curl -s "${album_art}" --output "$HOME/.config/hypr/waybar/scripts/cover.jpeg"
echo "$HOME/.config/hypr/waybar/scripts/cover.jpeg"

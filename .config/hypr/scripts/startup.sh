#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>
##
## Autostart Programs

# Kill already running process
_ps=(waybar mako)
for _prs in "${_ps[@]}"; do
	if [[ $(pidof ${_prs}) ]]; then
		killall -9 ${_prs}
	fi
done

# Polkit agent
/usr/lib/polkit-kde-authentication-agent-1 & # Used for user sudo graphical elevation

# Launch Systray Applets
exec blueman-applet & # Systray app for BT

# Set background based on Theme
# ~/.config/hypr/scripts/bgaction & # Sets the background based on theme
~/.config/hypr/scripts/changeWallpaper & # Sets the background based on theme

# Apply themes
~/.config/hypr/scripts/gtkthemes &

# Lauch notification daemon (mako)
~/.config/hypr/scripts/notifications &

# Lauch statusbar (waybar)
~/.config/hypr/scripts/statusbar &

# Start network manager applet
exec nm-applet --indicator &

# Start mpd
exec mpd &

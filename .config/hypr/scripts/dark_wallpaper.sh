#!/usr/bin/env bash

WALLPAPER_DIR="${HOME}/Pictures/wallpapers"

while :; do

  OLDIFS=$IFS
  IFS=$'\n'
  for wallpaper in $(hyprctl hyprpaper listloaded); do
    hyprctl hyprpaper unload "$wallpaper"
  done
  IFS=$OLDIFS

  # choosing only darkish wallpapers
  brightness=256
  while ((brightness > 90)); do
    wallpaper="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
    bright=$(vips avg "$wallpaper")
    brightness=$(echo $bright | cut -d',' -f1)
    #echo $brightness
  done

  for display in $(hyprctl monitors | grep "Monitor" | cut -d " " -f 2); do
    hyprctl hyprpaper preload "$wallpaper"
    hyprctl hyprpaper wallpaper "$display,$wallpaper"
  done

  sleep 666

done

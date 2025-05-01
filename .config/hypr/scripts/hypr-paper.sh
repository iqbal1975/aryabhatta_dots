#!/usr/bin/env bash

CACHE=$HOME/.cache/current_wallpaper.png

# Setup wallaper directory and monitor names.
DIR="$HOME/Pictures/wallpapers/nord-background/"
MONITOR1="eDP-1"
# MONITOR2="DP-2"

# Get a list of the .png files in the directory.
readarray -d '' papers < <(find "$DIR" \( -name '*.png' -o -name '*.jpeg' -o -name '*.jpg' \) -print0)

cd $HOME/.config/hypr/

# Get the length of the list of files.
length=${#papers[@]}

# Get the first random index.
first=$((1 + $RANDOM % $length - 1))

function dif_random {
  second=$((1 + $RANDOM % $length - 1))

  # Check to see if the second random index is equal
  # to the first, if so, find a new one.
  if [ $1 -eq $second ]; then
    dif_random "$1"
  else
    return $second
  fi
}

# Make sure that there is more than one file.
# This avoids an infinite loop.
if [ $length -gt 1 ]; then
  dif_random "$first"
  second=$?
else
  second=$first
fi

# Use the random indexes to get the two filenames
PAPER_ONE=${papers[$first]}
# PAPER_TWO=${papers[$second]}

WALL=${PAPER_ONE}
cp ${WALL} ${CACHE}

# Check to see if hyprpaper is running
if pgrep -x "hyprpaper" >/dev/null; then
  # If hyprpaper is running, select two new preloaded wallpapers
  hyprctl hyprpaper wallpaper "${MONITOR1},${PAPER_ONE}"
  # hyprctl hyprpaper wallpaper "${MONITOR2},${PAPER_TWO}"
else
  # Remove the old conf file.
  rm -f hyprpaper.conf

  # If it's not running, generate a new hyprpaper.conf
  for p in "${papers[@]}"; do
    echo "preload = ${p}" >>hyprpaper.conf
  done

  echo "wallpaper = ${MONITOR1},${PAPER_ONE}" >>hyprpaper.conf
  # echo "wallpaper = ${monitor2},${paper_two}" >> hyprpaper.conf

  # Start hyprpaper
  hyprpaper &
fi

# -----------------------------------------------------
# Send notification
# -----------------------------------------------------
notify-send "Wallpaper updated" "With image ${PAPER_ONE}"

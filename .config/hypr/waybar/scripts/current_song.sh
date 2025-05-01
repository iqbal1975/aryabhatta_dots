#!/usr/bin/env bash

PLAYER_STATUS=$(playerctl -s -p spotify status | tail -n1)
# Replace &'s in artist name/song title with +'s to avoid parsing issues
ALBUM=$(playerctl -p spotify metadata album | sed 's/&/+/g')
ARTIST=$(playerctl -p spotify metadata artist | sed 's/&/+/g')
TITLE=$(playerctl -p spotify metadata title | sed 's/&/+/g')

if [[ $PLAYER_STATUS == "Paused" || $PLAYER_STATUS == "Playing" ]]; then
  echo "${TITLE} - ${ARTIST} - ${ALBUM}"
elif [[ $PLAYER_STATUS == "Stopped" ]]; then
  echo "No Music Playing"
else
  echo "Music Player Offline"
fi

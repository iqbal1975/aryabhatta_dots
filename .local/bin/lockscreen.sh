#!/bin/bash

nwg-wrapper -s swaylock-time.sh -o eDP-1 -r 1000 -c timezones.css -p right -mr 50 -a start -mt 0 -j right -l 3 -sq 31 &

PIC=$(rffd -p /home/iqbal/Pictures/wallpapers/nature/)

sleep 0.5 && swaylock --image $PIC && pkill -f -31 nwg-wrapper
# sleep 2 && ~/.config/hypr/scripts/lockscreen && pkill -f -31 nwg-wrapper

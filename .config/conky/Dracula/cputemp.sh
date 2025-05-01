#!/bin/bash

# Main
cpuTemp=$(sensors | grep CPU | head -1 | awk -F '+' '{print $2}')

if [[ -n $cpuTemp ]]; then 
    echo "$cpuTemp"; 
else 
    echo "n/a"; 
fi

exit

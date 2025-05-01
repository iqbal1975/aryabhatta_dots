#!/usr/bin/env bash
#  _   _           _       _
# | | | |_ __   __| | __ _| |_ ___  ___
# | | | | '_ \ / _` |/ _` | __/ _ \/ __|
# | |_| | |_) | (_| | (_| | ||  __/\__ \
#  \___/| .__/ \__,_|\__,_|\__\___||___/
#       |_|
#
# by Stephan Raabe (2023)
# Modified by Iqbal Thaker (2023)
# ----------------------------------------------------------
# Requires pacman-contrib trizen

# ----------------------------------------------------------
# Define thresholds for color indicators
# ----------------------------------------------------------

threshold_green=0
threshold_yellow=25
threshold_red=100

# ----------------------------------------------------------
# Calculate available updates pacman and aur (with trizen)
# ----------------------------------------------------------

if ! updates_arch=$(checkupdates 2>/dev/null | wc -l); then
	updates_arch=0
fi

if ! updates_aur=$(trizen -Su --aur --quiet | wc -l); then
	updates_aur=0
fi

packages=$(("$updates_arch" + "$updates_aur"))

mapfile -t updates < <($HOME/.local/bin/check)

# ----------------------------------------------------------
# Testing
# ----------------------------------------------------------

# Overwrite updates with numbers for testing
# packages=100

# test JSON output
# printf '{"text": "0", "alt": "0", "tooltip": "Updates 0", "class": "red"}'
# exit

# ----------------------------------------------------------
# Parsing Function
# ----------------------------------------------------------

stringToLen() {
	STRING="$1"
	LEN="$2"
	if [ ${#STRING} -gt "$LEN" ]; then
		echo "${STRING:0:$((LEN - 2))}.."
	else
		printf "%-20s" "$STRING"
	fi
}

# ----------------------------------------------------------
# Output in JSON format for Waybar Module custom-updates
# ----------------------------------------------------------

text=${#updates[@]}
tooltip="<b> Updates (Arch + AUR) - $text</b>\n"
tooltip+=" <b>$(stringToLen "PkgName" 20) $(stringToLen "PrevVersion" 20) $(stringToLen "NextVersion" 20)</b>\n"

for i in "${updates[@]}"; do
	# shellcheck disable=2046
	update="$(stringToLen $(echo "$i" | awk '{print $1}') 20)"
	# shellcheck disable=2046
	prev="$(stringToLen $(echo "$i" | awk '{print $2}') 20)"
	# shellcheck disable=2046
	next="$(stringToLen $(echo "$i" | awk '{print $4}') 20)" # skipping '->' string
	tooltip+="<b> $update </b>$prev $next\n"
done
tooltip=${tooltip::-2}

css_class="green"

if [ "$packages" -gt $threshold_yellow ]; then
	css_class="yellow"
fi

if [ "$packages" -gt $threshold_red ]; then
	css_class="red"
fi

if [ "$packages" -gt $threshold_green ]; then
	printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}' "$packages" "$text" "$tooltip" "$css_class"
else
	printf '{"text": "0", "alt": "0", "tooltip": "System Updated ", "class": "white"}'
fi

# -----------------------------------------------------
# Output in JSON format for Waybar Module custom-updates
# -----------------------------------------------------

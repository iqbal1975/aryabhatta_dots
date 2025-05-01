#!/bin/sh

DIR=/home/iqbal/.local/bin/upd
UPD=$DIR/updates
UPV=$DIR/upd_versions
percentage="100" # don't move [5]

if [ ! -s ${UPV} ]; then
	percentage="0" # don't move [9]
	class="up-to-date"
	tooltip="0"
else
	if [ "$(cat ${UPV})" = "refreshing" ]; then
		percentage="60"
		class="refreshing"
		tooltip="${class} db..."
	else
		[ "$(tail -n 1 ${UPD})" -gt "$(tail -n 2 ${UPD} | head -n 1)" ] &&
			class="new-updates" ||
			class="updates"

		tooltip=$(tail -n 1 ${UPD})
	fi
fi

[ ! -x /usr/bin/fuzzel ] &&
	menu="[on click: *please install 'fuzzel'*]\n[right-click: refresh db]" ||
	menu="[on click: view updates]\n[right-click: refresh db]"

synced="Last sync: $(cat $DIR/lastsync)"

if [ "${percentage}" != "30" ]; then
	if [ "${class}" = "refreshing" ]; then
		printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"$tooltip\"}"
	else
		printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"Updates: $tooltip\n$synced\n\n$menu\"}"
		# Alternatively, if you want the number of updates to be shown on the bar,
		# comment the command above and uncomment the one below:
		#printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"Updates: $tooltip\n$synced\n\n$menu\",\"text\":\"$tooltip\"}"
	fi
else
	class="offline"

	printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"$class\"}"
fi

if [ "${class}" = "new-updates" ]; then
	cat ${UPV} | wc -l >${UPD}

	# If you want to add an acoustic notification, this would be the place, e.g.:
	# aplay -q /path/to/sound.file
fi

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"

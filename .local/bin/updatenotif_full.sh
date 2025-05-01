#!/bin/sh
#
#[v3.1.0]
#
### Description:
#
# This script - let's call it 'updatenotif.sh' -
# can be used as a standalone as well as part
# of a waybar module in order to notify about
# Arch Linux package updates.
#
# Run this script at startup of your graphical
# environment. It will check for updates every
# 30 minutes.
#
#
### Dependencies:
#
# 'libnotify'
# 'pacman-contrib'
# 'fnott' (or a notification daemon of your choice),
# please also see: "https://wiki.archlinux.org/title/Desktop_notifications"
# 'fuzzel' (optional - waybar only)

[ "${ULOCKER}" != "$0" ] &&
	exec env ULOCKER="$0" flock -en "$0" "$0" "$@" || :

UPD=/tmp/updates
UPV=/tmp/upd_versions

sed_pc() {
	[ -x /usr/bin/waybar ] &&
		sed -i -e "5s/percentage=[0-9\"]*/percentage=\"$1\"/" \
			-e "9s/percentage=[0-9\"]*/percentage=\"$2\"/" \
			~/.local/bin/updbar.sh
}

rm -f ${UPV}

sleep 5 && echo 0 >${UPD}

while [ -f ${UPD} ]; do
	pkill -x -SIGRTMIN+9 waybar && echo "refreshing" >${UPV}

	if ping -n -c 1 www.archlinux.org >/dev/null 2>&1; then
		sed_pc 100 0

		checkupdates >${UPV} && date '+%F %T' >/tmp/lastsync
		cat ${UPV} | wc -l >>${UPD}

		[ -x /usr/bin/notify-send ] &&
			[ ! "$(tail -n 1 ${UPD})" -le "$(tail -n 2 ${UPD} | head -n 1)" ] &&
			notify-send -t 10000 "UPDATES" "$(tail -n 1 ${UPD})"

		sleep 0.5h
	else
		sed_pc 30 30 && : >${UPV}

		sleep 1m
	fi
done

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"

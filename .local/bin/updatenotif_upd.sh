#!/usr/bin/env bash
#
# If you intend to integrate this script in the module,
# name it e.g. 'updatenotif_upd.sh', place it inside
# '~/.local/bin/' and add:
#
#		"on-click-middle": "~/.local/bin/updatenotif_upd.sh",
#
# to the 'on-click-*' arrays inside the module.
# The method above requires working desktop notifications
# and 'libnotify'.
# Otherwise just run the script from your terminal.

UP="UPDATES-module"
RI="RI-module"
UTD="up-to-date"
UPD="Update"
SCR1=~/.local/bin/updatenotif.sh
SCR2=~/.local/bin/ri.sh
URL1=https://bbs.archlinux.org/viewtopic.php?id=279522
URL2=https://bbs.archlinux.org/viewtopic.php?id=290491

BLUE='\e[1;34m'
GREEN='\e[1;36m'
NOCOLOR='\e[0m'

grp() {
	grep $(curl -s "$1" | head -n 6 | grep "MODULE" |
		cut -d' ' -f 4) "$2" >/dev/null 2>&1
}

nsd() {
	[ -x /usr/bin/notify-send ] &&
		notify-send -t 5000 "$@"
}

ping -n -c 1 archlinux.org >/dev/null 2>&1 || exit 2

echo

outpt() {
	if [ -f ${SCR1} ]; then
		if grp ${URL1} ${SCR1}; then
			printf "${UP}: ${BLUE}${UTD}${NOCOLOR}\n"

			nsd "${UP}" "${UTD}" --urgency=low
		else
			printf "${UP}: ${GREEN}${UPD}${NOCOLOR}: \"${URL1}\"\n"

			nsd "${UP}" "${UPD} available"
		fi
	fi

	if [ -f ${SCR2} ]; then
		if grp ${URL2} ${SCR2}; then
			printf "${RI}: ${BLUE}${UTD}${NOCOLOR}\n"

			nsd "${RI}" "${UTD}" --urgency=low
		else
			printf "${RI}: ${GREEN}${UPD}${NOCOLOR}: \"${URL2}\"\n"

			nsd "${RI}" "${UPD} available"
		fi
	fi
}

outpt | column -t

echo

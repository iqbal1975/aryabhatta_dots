#!/usr/bin/env bash
#
#[v4.0.5]
#
# This script depends on 'pacman-contrib'

[ "${ULOCKER}" != "$0" ] &&
	exec env ULOCKER="$0" flock -en "$0" "$0" "$@" || :

UPD=/tmp/upd/updates
UPV=/tmp/upd/versions
UPN=/tmp/upd/versions.new
UPO=/tmp/upd/versions.old
UBR=~/.local/bin/updbar.py

sed_pc() {
	sed -i -e "10s/percentage\ =\ [0-9]*/percentage\ =\ $1/" \
		-e "22s/percentage\ =\ [0-9]*/percentage\ =\ $2/" ${UBR}
}

sed_cl() {
	sed -i "27s/clss =\ .*\ #/clss\ =\ \"$1\"\ #/" ${UBR}
}

sed_nw() {
	local IFS=$'\n'
	for i in $(<${UPN}); do
		sed -i "s/$i.*/&\ \ \ NEW/" ${UPV}
	done

	sed -i "s/NEW.*/NEW/g" ${UPV}
}

sig() {
	pkill -x -SIGRTMIN+9 waybar
}

mkdir -p /tmp/upd
: >${UPN}
echo 0 >${UPD}

echo "$$" >/tmp/upd/PID

while [ -f ${UPD} ]; do
	echo "refreshing" >${UPV}
	sig

	checkupdates -n >${UPO}

	if ping -n -c 1 -W 5 archlinux.org >/dev/null 2>&1; then
		sed_pc 100 0
		checkupdates | tee ${UPV} | wc -l >${UPD}

		if diff ${UPV} ${UPO} >/dev/null 2>&1; then
			[ -s ${UPV} ] || : >${UPN}

			sed_cl updates
			sed_nw
			sig
		else
			comm -23 ${UPV} ${UPO} 2>/dev/null | cut -d' ' -f 1,2 >${UPN}

			sed_cl new-updates
			sed_nw
			sig

			# If you want to add an acoustic notification, this would be the place
			# (needs logging out/in to take effect):
			#paplay /path/to/sound.file &
		fi

		sleep 10 && sed_cl updates
		sig
		sleep 1.0h # Interval in which to check for updates
	else        # 'offline' mode
		if checkupdates -n >/dev/null 2>&1; then
			sed_pc 70 70
			: >${UPV}
			sig

			sleep 3m # Interval in which to retry ('updates' state)
		else
			sed_pc 30 30
			: >${UPV}
			sig

			sleep 3m # Interval in which to retry ('up-to-date' state)
		fi
	fi
done

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"

#!/usr/bin/env bash

DIR=/home/iqbal/.local/bin/upd
UPD=$DIR/updates
UPV=$DIR/versions
UPN=$DIR/versions.new
UPO=$DIR/versions.old
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
	fi

	if [ $(pidof waybar) ]; then
		sleep 10 && sed_cl updates
		sig
	else
		sed_cl updates
	fi
else
	if checkupdates -n >/dev/null 2>&1; then
		sed_pc 70 70
		: >${UPV}
		sig
	else
		sed_pc 30 30
		: >${UPV}
		sig
	fi
fi

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"

#!/usr/bin/env bash
#
#
# This script depends on 'bemenu-wayland'

set -e

DIR=/home/iqbal/.local/bin/upd
UPV=$DIR/versions
UPN=$DIR/versions.new

[[ "$(<${UPV})" = "refreshing" ]] && exit
[ $(pidof bemenu) ] && pkill -x bemenu && exit

ps -q $(</tmp/upd/PID) >/dev/null 2>&1 &&
	STT="running" || STT="stopped"

bmn() {
	bemenu --fn 'monospace 12' -i -l 15 -n -s -w -W 0.5 \
		--cw 1 --cf \#555555 --nf \#999999 --hf \#FFFFFF \
		--tf \#999999 "$1"
}

pcl() {
	footclient -w 1600x900 --title=pclinfo ~/.local/bin/pclinf.sh &
}

if [ -s ${UPV} ]; then
	bmn --prompt="[Total: $(cat ${UPV} | wc -l) |New: $(cat ${UPN} |
		wc -l) |${STT}] " <${UPV} >/dev/null

	pcl
else
	if python ~/.local/bin/updbar.py | grep "up-to-date" >/dev/null 2>&1; then
		echo " " | bmn --prompt="[${STT}] " >/dev/null
	else
		checkupdates -n | bmn --prompt="[offline|${STT}] " >/dev/null

		pcl
	fi
fi

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"

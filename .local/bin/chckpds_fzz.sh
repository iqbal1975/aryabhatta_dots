#!/usr/bin/env bash

DIR=/home/iqbal/.local/bin/upd
UPV=$DIR/versions
UPN=$DIR/versions.new

[[ "$(<${UPV})" = "refreshing" ]] && exit
[ $(pidof fuzzel) ] && pkill -x fuzzel && exit

ps -q $(</tmp/upd/PID) >/dev/null 2>&1 &&
	STT="running" || STT="stopped"

fzz() {
	fuzzel -d -w 80 --font=monospace:size=9 --background=111111EE \
		--border-color=111111FF --text-color=999999FF \
		--selection-text-color=FFFFFFBB --log-level=none \
		--log-no-syslog "$1"
}

pcl() {
	[[ $(ps -ef | grep '[f]oot --server') ]] &&
		footclient -w 1800x900 ~/.local/bin/pclinf.sh &
}

if [ -s ${UPV} ]; then
	fzz --prompt="[Total: $(cat ${UPV} | wc -l) |New: $(cat ${UPN} |
		wc -l) |${STT}] " <${UPV} >/dev/null

	pcl
else
	if python ~/.local/bin/updbar.py | grep "up-to-date" >/dev/null 2>&1; then
		echo " " | fzz --prompt="[${STT}] " >/dev/null
	else
		checkupdates -n | fzz --prompt="[offline|${STT}] " >/dev/null

		pcl
	fi
fi

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"

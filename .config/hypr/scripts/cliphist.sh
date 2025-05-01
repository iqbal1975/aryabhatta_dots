#!/usr/bin/env sh
roconf="$HOME/.config/hypr/rofi/clipboard.rasi"

case $1 in
c)
	cliphist list | rofi -dmenu -theme-str 'entry { placeholder: "Copy...";}' -config $roconf | cliphist decode | wl-copy
	;;
d)
	cliphist list | rofi -dmenu -theme-str 'entry { placeholder: "Delete...";}' -config $roconf | cliphist delete
	;;
w)
	if [ $(echo -e "Yes\nNo" | rofi -dmenu -theme-str 'entry { placeholder: "Clear Clipboard History?";}' -config $roconf) == "Yes" ]; then
		cliphist wipe
	fi
	;;
t)
	echo ""
	echo "󰅇 Clipboard history"
	;;
*)
	echo "cliphist.sh [action]"
	echo "c :  Cliphist list and copy selected"
	echo "d :  Cliphist list and delete selected"
	echo "w :  Cliphist wipe database"
	echo "t :  Display tooltip"
	;;
esac

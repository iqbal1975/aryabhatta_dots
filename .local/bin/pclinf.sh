#!/usr/bin/env bash
#
#
cat <<MOS

──────────────────────────────────────────────────────────────────────────────

This script depends on:

'foot' (server)
'fzf'
'w3m'
'wl-clipboard'

If you intend to replace the "default" menu with this script,
then put it inside '~/.local/bin/', and edit the module like so:

		"on-click": "footclient -w 1800x1000 ~/.local/bin/pclinf.sh",

──────────────────────────────────────────────────────────────────────────────

MOS

_chg="Changelog ['q': return]"
_pct="pactree -r"
_pkk="pacman -Qkk"
_nqu="New query"

DIR=/home/iqbal/.local/bin/upd
UPV=$DIR/versions
URL=https://gitlab.archlinux.org/archlinux/packaging/packages/
PS3="q) Quit
───────────────────────────
: "

pmn() {
	echo "Package '$(wl-paste)':"
	echo
	echo "1) ${_chg}"
	echo "2) ${_pct}"
	echo "3) ${_pkk}"
	echo "4) ${_nqu}"
}

fzf_upd() {
	fzf --cycle --color=fg+:#1793D1 --preview='pacman -Qii {1}' \
		--preview-window=top,60% --bind 'right:toggle-preview-wrap' \
		--layout=reverse
}

wlp() {
	cut -d' ' -f 1 | wl-copy
}

if [ -s ${UPV} ]; then
	fzf_upd <${UPV} | wlp
else
	checkupdates -n | fzf_upd | wlp
fi

if [ -z "$(wl-paste)" ]; then
	echo
	echo "Exiting..."
	sleep 0.5
	exit
fi

echo
echo "Package '$(wl-paste)':"
echo

select cmd in "${_chg}" \
	"${_pct}" \
	"${_pkk}" \
	"${_nqu}"; do
	case $cmd in

	"${_chg}")
		if curl -s ${URL}/$(wl-paste | cut -d'-' -f 1,2)/-/commits/main |
			grep "You are being\|redirected" >/dev/null 2>&1; then
			echo
			echo "Sorry, the URL cannot be resolved."
			echo "Please use the search function on 'https://gitlab.archlinux.org/archlinux/packaging/packages/'"
			echo
		else
			w3m "${URL}/$(wl-paste | cut -d'-' -f 1,2)/-/commits/main"
			echo
		fi
		pmn
		;;
	"${_pct}")
		echo
		pactree -r $(wl-paste)
		echo
		pmn
		;;
	"${_pkk}")
		echo
		pacman -Qkk $(wl-paste)
		echo
		pmn
		;;
	"${_nqu}")
		[[ "$(<${UPV})" = "refreshing" ]] && exit 1

		if [ -s ${UPV} ]; then
			fzf_upd <${UPV} | wlp
		else
			checkupdates -n | fzf_upd | wlp
		fi

		if [ -z "$(wl-paste)" ]; then
			echo
			echo "Exiting..."
			sleep 0.5
			break
		fi

		echo
		pmn
		;;
	*)
		break
		;;
	esac
done

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"

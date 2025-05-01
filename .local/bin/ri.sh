#!/usr/bin/env bash
#
#[v0.7.b]
#
# This script depends on 'bemenu-wayland' 'jq'

[ $(pidof bemenu) ] && pkill -x bemenu

class="enabled" # don't move [10]

RIN=/tmp/riNHB
TMR=/tmp/riTMR
LCS=~/.config/RI
CFG=${LCS}/ri.conf
RIT=${LCS}/ri.txt

tmo_cfg=$(jq -r .timeout_sec ${CFG})
snd_q_cfg=$(jq -r .sound_queue ${CFG})
snd_e_cfg=$(jq -r .sound_end ${CFG})
prs_cfg=$(jq -r .prompt_string ${CFG})
psr_cfg=$(jq -r .persist_reboot ${CFG})
trp_cfg=$(jq -r .transparent ${CFG})
lns_cfg=$(jq -r .lines ${CFG})

if [ -f ${CFG} ]; then
	if [[ "${tmo_cfg}" -lt 15 ]] || [[ "${tmo_cfg}" -gt 300 ]]; then
		tmo_cfg=60
	fi

	if [[ "${psr_cfg}" = "yes" ]]; then
		RIB=~/.cache/riBRK
	else
		RIB=/tmp/riBRK

		rm -f ~/.cache/riBRK
	fi
else
	tmo_cfg=60
	RIB=/tmp/riBRK

	rm -f ~/.cache/riBRK
fi

[ -f ${RIB} ] || date '+%H:%M' >${RIB}

lst_brk=$(tail -n 1 ${RIB})
cnt_brk=$(cat ${RIB} | wc -l)

menu="<span color='#555555'>On click: on|off\nRight-click: skip</span>"

prt() {
	printf '%s\n' "{\"class\":\"$class\",\"tooltip\":\
			\"RI-mode: $class\nTimeout: ${tmo_cfg}s\nRewards: $cnt_brk  @$lst_brk\n$menu\"}"

	rm -f ${TMR}
}

trap prt EXIT

[ -s ${RIN} ] && exit

pgrep -f rinhibit >/dev/null 2>&1 && exit

[[ "$(($(date +"%s") - $(stat -c "%Y" "/proc/$(pidof -s waybar)")))" -lt "10" ]] && exit

tmr() {
	while pidof bemenu >/dev/null 2>&1; do
		echo "1" >>${TMR}
		sleep 1
	done
}

if [ -f ${CFG} ] && [[ "${trp_cfg}" = "yes" ]]; then
	bmn() {
		timeout ${tmo_cfg} bemenu -l "${lns_cfg}" -n -s -w --cw 1 --prompt="${prs_cfg} " \
			--fn 'monospace 15' --fixed-height --monitor=all --cf \#00000000 \
			--nf \#999999 --af \#999999 --hf \#00CF52 --tf \#999999 \
			--nb \#000000E6 --hb \#000000E6 --sb \#000000E6 \
			--ab \#000000E6 --fb \#00000000 --tb \#000000E6 &
	}
else
	bmn() {
		timeout ${tmo_cfg} bemenu -l "${lns_cfg}" -n -s -w --cw 1 --prompt="${prs_cfg}" \
			--fn 'monospace 15' --fixed-height --monitor=all --cf \#00000000 \
			--tf \#999999 --nf \#999999 --af \#999999 --hf \#00CF52 &
	}
fi

if [[ "${class}" = "enabled" ]]; then
	paplay ${LCS}/${snd_q_cfg} &
	# Alternatively (requires 'alsa-utils'):
	#aplay -q --file-type=wav ${LCS}/${snd_q_cfg} &

	# Popup (requires 'libnotify'):
	#notify-send -t 10000 "RI" "10...9...8..."

	sleep 10

	if [ ! -s ${RIN} ]; then
		if [ -f ${RIT} ]; then
			shuf -n 1 ${RIT} | bmn >/dev/null

			tmr
		else
			echo "Rest your eyes..." | bmn >/dev/null

			tmr
		fi

		TMT=$((${tmo_cfg} - 5))
		if [[ "$(cat ${TMR} | wc -l)" -lt ${TMT} ]]; then
			echo "$(tail -n 1 ${RIB})" >${RIB}
		else
			date '+%H:%M' >>${RIB}
		fi

		lst_brk=$(tail -n 1 ${RIB})
		cnt_brk=$(cat ${RIB} | wc -l)

		paplay ${LCS}/${snd_e_cfg}
		# Alternatively (requires 'alsa-utils'):
		#aplay -q --file-type=wav ${LCS}/${snd_e_cfg}
	fi
fi

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=290491"

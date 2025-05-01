#!/usr/bin/env bash

RIN=/tmp/riNHB
CFG=~/.config/RI/ri.conf
psr_cfg=$(jq -r .persist_reboot ${CFG})

if [ -f ${CFG} ]; then
	if [[ "${psr_cfg}" = "yes" ]]; then
		RIB=~/.cache/riBRK
	else
		RIB=/tmp/riBRK

		rm -f ~/.cache/riBRK
	fi
else
	RIB=/tmp/riBRK

	rm -f ~/.cache/riBRK
fi

echo "$(tail -n 1 ${RIB})" >${RIB}
echo "skip" >${RIN} && sleep 15 && : >${RIN}

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=290491"

#!/usr/bin/env bash

RIN=/tmp/riNHB
RIS=~/.local/bin/ri.sh

if grep 'class="enabled"' ${RIS} >/dev/null 2>&1; then
	sed -i "10s/class=.*\ #/class=\"disabled\"\ #/" ${RIS}
else
	sed -i "10s/class=.*\ #/class=\"enabled\"\ #/" ${RIS}
fi

echo "skip" >${RIN} && sleep 1 && : >${RIN}

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=290491"

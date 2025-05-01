#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/ojhaUNYetsU

shopt -s autocd

# silence_autocd
# - Hack to stop autocd from printing the directory after autocd'ing.
# - Unfortunately there is no clean way to do this except messing with
#   BASH_XTRACEFD, a poorly understood file descriptor that we are better not
#   to mess with, yet here we are.
# - Warning: This might break things, so try disabling it if something looks
#   off.
silence_autocd() {
	exec {BASH_XTRACEFD}>/dev/null
}

silence_autocd

# unsilence_autocd
# - Needed to undo the above temporarily.
# - Unfortunately, BASH_XTRACEFD is used for other things besides autocd.
# - In those cases, I need to undo and redo the redirection.
# - Currently "set -x" is the only notable user of BASH_XTRACEFD that I've
#   found so far, but there could be others in the future.
# - For the time being, I pray to the Bash Gods to provide a native way to
#   disable autocd printing soon.
unsilence_autocd() {
	exec {BASH_XTRACEFD}>/dev/stdout
}

# custom set
function set() {
	# if calling "set -x", undo the silencing of autocd
	if [[ "$#" == 1 && "$1" == "-x" ]]; then
		command set -x
		unsilence_autocd
	elif [[ "$#" == 1 && "$1" == "+x" ]]; then
		silence_autocd
		command set +x
	else
		command set "$@"
	fi
}

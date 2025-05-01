#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=bNITSDWht6w

# add to your .bashrc or something like that

# custom shopt
# It pipes into column -t if there are no arguments,
# because the default with broken lines is not very readable.
# And while I'm at it, make 'on' green and 'off' red.
function shopt() {
	if [ $# -eq 0 ]; then
		local output=$(command shopt | column -t)
		output=$(echo "$output" | sed -E "s/(on$)/$(tput setaf 2)\1$(tput sgr0)/g")
		output=$(echo "$output" | sed -E "s/(off$)/$(tput setaf 1)\1$(tput sgr0)/g")
		echo "$output"
	else
		command shopt "$@"
	fi
}

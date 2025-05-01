#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/q26DJ5qOXxM

# custom declare -F
# - add filename and table output to "declare -F"
# - this is based on the "declare -F name" output when shopt extdebug is on
function declare() {
	if [[ $# == 1 && "$1" == "-F" ]]; then
		shopt -s extdebug
		source <(
			command declare -F |
				awk '
        {
          print "declare -F " $NF;
        }'
		) |
			sed -E "s|$HOME|~|g" |
			column -t
		shopt -u extdebug
	else
		command declare "$@"
	fi
}

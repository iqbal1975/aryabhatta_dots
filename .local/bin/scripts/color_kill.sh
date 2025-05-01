#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/cZIxuQuY7RE

# custom kill -l
# - column format and color the texts after SIG
# - add some descriptions
function kill() {
	local green='\x1b[32m'
	local bold='\x1b[1m'
	local reset='\x1b[0m'

	if [[ "$#" == 1 && "$1" == "-l" ]]; then
		command kill -l |
			xargs -n2 |
			column -t |
			sed -e 's/SIG([[:alnum:]]+)/'"$green"'SIG'"$reset""$bold"'\1'"$reset"'/g' \
				-e 's/(.*TERM.*)/&\t(default)/g' \
				-e 's/(.*INT.*)/&\t(Ctrl-C)/g' \
				-e 's/(.*KILL.*)/&\t(cannot ignore)/g' \
				-e 's/(.*TSTP.*)/&\t(Ctrl-Z)/g' |
			column -t -s $'\t'
	else
		command kill "$@"
	fi
}

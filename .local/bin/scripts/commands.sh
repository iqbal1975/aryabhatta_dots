#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/9sKEQ-DFL8I

# commands
# - list all commands in your PATH, and their directories
function commands() {
	local green='\x1b[32m'
	local reset='\x1b[0m'

	compgen -c |
		while read -r command; do
			printf "%s\t" "$command"
			type -P $command || printf "\n"
		done |
		# remove lines with only one word
		# make first word green
		# remove everything after last "/"
		command sed -E -n '/^([^\t]+)\t([^\t]*)\/[^\t]+$/ {s//'"${green}"'\1'"${reset}"'\t\2/g; p}' |
		column -t -s $'\t'
}

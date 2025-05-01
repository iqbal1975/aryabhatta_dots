#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=Dl2n_fcDjkE

### Add this to your .bashrc

# custom fdisk
# - add color when called with -l or -x
# - prepend sudo
function fdisk() {
	local green='\x1b[32m'
	local bold='\x1b[1m'
	local blue='\x1b[34m'
	local yellow='\x1b[33m'
	local reset='\x1b[0m'

	if [[ "$@" =~ -l|--list|-x|--list-details ]]; then
		command sudo fdisk --color=always "$@" |
			sed -E -e 's/ ([0-9]+(\.[0-9]+)?)([A-Z]+) / '"${green}${bold}"'\1'"${reset}${green}"'\3'"${reset}"' /g' \
				-e 's/(^\/dev\/)([a-z0-9]+) /'"${blue}"'\1'"${reset}${bold}${blue}"'\2'"${reset}"' /g' \
				-e 's/(Disk )(\/dev\/)([a-z0-9]+): ([0-9]+(\.[0-9]+)?) ([[:alpha:]]+),/\1'"${reset}${blue}"'\2'"${reset}${bold}${blue}"'\3'"${reset}${bold}"': '"${green}${bold}"'\4'"${reset}${green}"'\6'"${reset}${bold}"',/g' \
				-e 's/(Disk model: )(.*)/\1'"${reset}${yellow}"'\2'"${reset}"'/g' \
				-e 's/(Disklabel type: )(.*)/\1'"${reset}${yellow}"'\2'"${reset}"'/g'
	else
		command sudo fdisk --color=always "$@"
	fi
}

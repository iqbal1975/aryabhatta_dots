#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=Dl2n_fcDjkE

### Add this to your .bashrc

# custom free
# - add common options
# - add color
# - add footer
function free() {
	local green='\x1b[32m'
	local cyan='\x1b[36m'
	local bold='\x1b[1m'
	local reset='\x1b[0m'
	command free --human --si --total "$@" |
		sed -E -e 's/([0-9]+(\.[0-9]+)?)([A-Z]+)/'"${green}${bold}"'\1'"${reset}${green}"'\3'"${reset}"'/g' \
			-e 's/Total:/'"${bold}"'Total:'"${reset}"'/g'

	# print info footer
	local info_footer="---------------------------------------------------------------------------------------\n"
	info_footer+="${cyan}shared${reset}:     Memory used (mostly) by 'tmpfs'\n"
	info_footer+="${cyan}buff/cache${reset}: Memory used by kernel buffers, plus memory used by the page cache and slabs\n"
	info_footer+="${cyan}available${reset}:  Estimation of how much memory is available for starting new applications"
	echo -e "$info_footer"
}

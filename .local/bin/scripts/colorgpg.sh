#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=cDlWF48xaGQ

# Add this to your .bashrc

# custom gpg
# - add color output
# - replace $HOME with ~
# - Add footer with explanation of terms
#
# Note: For this to work, make sure your gpg.conf has the following lines:
#   with-fingerprint
#   with-subkey-fingerprint
#   keyid-format 0xlong
function gpg() {
	local bold='\x1b[1m'
	local green='\x1b[32m'
	local blue='\x1b[34m'
	local yellow='\x1b[33m'
	local cyan='\x1b[36m'
	local purple='\x1b[35m'
	local reset='\x1b[0m'

	# if command contains --list-key, --list-keys, --list-secret-key,
	# --list-secret-keys or --list-public-keys
	if [[ "$@" =~ --list-(secret|public)?-?keys? ]]; then
		local output="$(command gpg "$@")"

		if [[ -z "$output" ]]; then
			return $?
		fi

		sed -e 's/(Key fingerprint \=)/'$yellow'\1'$reset'/g' \
			-e 's/(.*\.kbx)/'$yellow'Keyring: \1'$reset'/g' \
			-e 's/^uid[[:blank:]]+/uid   /g' \
			-e 's/(^uid.*\] )(.*)/\1'$green'\2'$reset'/g' \
			-e 's/(\[.*\])/'$cyan'\1'$reset'/g' \
			-e 's/(^pub|^sec)/'$bold$green'\1'$reset'/g' \
			-e 's/(^sub|^ssb|^uid)/'$bold'\1'$reset'/g' \
			-e 's/(\[expires: )([0-9]{4}-[0-9]{2}-[0-9]{2})(\].*)/'$cyan'\1'$blue'\2'$cyan'\3'$reset'/g' \
			-e 's/([0-9]{4}-[0-9]{2}-[0-9]{2})/'$blue'\1'$reset'/g' \
			-e 's/^$/------------------------------------------/g' \
			-e 's| ([[:alnum:]]*)/| '$purple'\1'$reset'/|g' \
			-e 's|'$HOME'|~|' <<<"$output"

		# print info footer
		local info_footer="------------------------------------------\n"

		info_footer+="${cyan}E${reset}=encryption, "
		info_footer+="${cyan}S${reset}=signing, "
		info_footer+="${cyan}C${reset}=certification, "
		info_footer+="${cyan}A${reset}=authentication\n"

		info_footer+="${green}${bold}pub${reset}=public primary key, "
		info_footer+="${bold}sub${reset}=public subkey,\n"

		info_footer+="${green}${bold}sec${reset}=secret primary key, "
		info_footer+="${bold}ssb${reset}=secret subkey,\n"

		info_footer+="${bold}uid${reset}=user ID, ${purple}algorithm${reset}/${bold}key-ID${reset}"
		echo -e "$info_footer"
	else
		command gpg "$@"
	fi
}

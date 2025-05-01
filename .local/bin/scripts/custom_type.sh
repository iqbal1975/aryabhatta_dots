#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/mYfEIZFlIwo

# Put this in your .bashrc or something like that

# pretty_print_directory
# - replace $HOME with ~
# - make everything before the last '/' green, and everything after white and
#   bold
# - takes a single argument or reads from stdin
function pretty_print_directory() {
	green='\x1b[32m'
	bold='\x1b[1m'
	reset='\x1b[0m'

	input=""
	if [[ "$#" == 0 ]]; then
		input="$(cat)"
	else
		input="$1"
	fi

	echo "$input" |
		sed -E 's:'"$HOME"':~: ; s:$HOME:~: ; s:(.*/)([^/]+):'"${green}"'\1'"${reset}${bold}"'\2'"${reset}"':'
}

# custom type
# - Adds the -a flag (show all matches, not just the first)
# - Pretty print paths
# - Show symlink targets.
# - If any line is an alias, highlight the first word, and include a nested
#   type call for that word.
function type() {
	local gray='\e[38;5;8m'
	local blue='\e[34m'
	local bold='\e[1m'
	local reset='\e[0m'

	output="$(command type -a "$@")"

	# if there is no output, return
	if [[ -z "$output" ]]; then
		return 1
	fi

	local regex_path='^[[:graph:]]+ is [[:graph:]]+$' # case "WORD is /some/path"
	local regex_alias='^[[:graph:]]+ is aliased to'   # case "WORD is aliased to"
	local regex_is='^[[:graph:]]+ is '                # case "WORD is ..."

	# For every output line
	while IFS= read -r line; do
		# If line has the form "WORD is /some/path", pretty print the path and add
		# symlink target, if any.
		if [[ "$line" =~ $regex_path ]]; then
			local word="${line%% is*}"
			local path="${line#* is }"
			local pretty_path="$(pretty_print_directory "$path")"
			local output_line="${bold}${word}${reset} is ${pretty_path}"

			# symlink stuff
			local symlink_path="$(realpath "$path")"
			if [[ "$symlink_path" != "$path" ]]; then
				local pretty_symlink_path="$(pretty_print_directory "$symlink_path")"
				output_line="${output_line} ${gray}->${reset} ${pretty_symlink_path}"
			fi

			printf '%b\n' "$output_line"

		# If line has the form "WORD is aliased to `ALIAS ...", highlight alias
		elif [[ "$line" =~ $regex_alias ]]; then
			# Note that forms can be either:
			# - "WORD is aliased to `ALIAS ...'" or
			# - "WORD is aliased to `ALIAS'"
			local word="${line%% is*}"
			local rest="${line#* is aliased to \`}"
			local alias="${rest%%[ \']*}"
			local rest="${rest#*${alias}}"

			local is_alias_different_command=false
			if [[ "$word" != "$alias" ]]; then
				is_alias_different_command=true
			fi

			# if the alias is different than the word, highligh as blue
			local alias_highlight=${bold}
			if [[ "$is_alias_different_command" = true ]]; then
				alias_highlight=${bold}${blue}
			fi

			printf '%b\n' "${bold}${word}${reset} is aliased to \`${alias_highlight}${alias}${reset}${rest}"

			# if the alias is different, recursively call 'type' on it. Indent two spaces.
			if [[ "$is_alias_different_command" = true ]]; then
				local alias_output="$(type "$alias" | sed 's/^/  /')"
				printf '%b\n' "$alias_output"
			fi

		# If a line has the form "WORD is ...", highlight word.
		# This is just the catch-all case.
		elif [[ "$line" =~ $regex_is ]]; then
			local word="${line%% is*}"
			local rest="${line#* is }"
			printf '%b\n' "${bold}${word}${reset} is ${rest}"
		else
			printf '%s\n' "$line"
		fi
	done <<<"$output"
}

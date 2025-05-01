#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=nf3ddQniw-o

# diffc - diff commands
# - allows to call as: diffc 'command one' 'command two'
#   instead of:        diff  <(command one) <(command two)
#   (Just to save typing a few characters. Lol I'm a lazy programmer)
function diffc() {
	if [[ "$#" != "2" ]]; then
		echo "diffc requires two arguments"
		return 1
	fi

	local command=$(printf 'diff <( %s ) <( %s )' "$1" "$2")
	echo $command
	eval $command
}

# diffh - diff history
# - make a diff of the output of the last two commands in the shell history
function diffh() {
	# first one is 2nd to last. second is last
	# remove preceeding spaces
	local first=$(fc -ln -2 -2)
	local second=$(fc -ln -1 -1)

	# print and run diff
	local command=$(printf 'diff <( %s ) <( %s )' "${first}" "${second}")
	echo $command
	eval $command

	local error_code=$?

	# replace this 'diffh' entry in history with the command
	history -s "$(echo $command)"

	return $error_code
}

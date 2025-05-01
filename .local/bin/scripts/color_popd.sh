#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Copy this into your .bashrc or something like that.

# custom dirs
# - default to 'dirs -v' format and colorize the output
function dirs() {
	# if no arguments, or single argument is -v or -c, then colorize
	if [ $# -eq 0 ] || { [ $# -eq 1 ] && { [ "$1" = "-v" ] || [ "$1" = "-c" ]; }; }; then
		# if argument is -c, run it (clear stack)
		if [ "$1" = "-c" ]; then
			command dirs -c
		fi

		# colorize output
		command dirs -v | command awk '
      BEGIN {
        green = "\033[32m";
        bold = "\033[1m";
        reset = "\033[0m";
      }
      {
        $1 = bold sprintf("%2d", $1) reset;
        $2 = gensub(/(.*\/)([^\/]+)/, green "\\1" reset bold "\\2" reset, "g", $2);
        print $1 "  " $2;
      }'
	else
		command dirs "$@"
	fi
}

# custom pushd
# - prints dirs if successful
function pushd() {
	command pushd "$@" >/tmp/pushd_out 2>&1
	if [ $? -ne 0 ]; then
		cat /tmp/pushd_out
		command rm /tmp/pushd_out
		return 1
	fi
	dirs
	command rm /tmp/pushd_out
}

# custom popd
# - same thing
function popd() {
	command popd "$@" >/tmp/popd_out 2>&1
	if [ $? -ne 0 ]; then
		cat /tmp/popd_out
		command rm /tmp/popd_out
		return 1
	fi
	dirs
	command rm /tmp/popd_out
}

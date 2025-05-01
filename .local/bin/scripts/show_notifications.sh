#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/WVyqVkGYb4k

# Add this somewhere in ~/.bashrc

# write_message
# - write a message on the lower right corner of the terminal
function write_message() {
	if [[ "$#" -eq 0 ]]; then
		echo "write_message: please provide a message"
		return
	fi

	local message="  ${*}  "

	# CSI sequences
	local csi="\033["
	local save_cursor_position="${csi}s"
	local restore_cursor_position="${csi}u"
	local erase_from_cursor_to_end_of_screen="${csi}J"
	local reset="${csi}0m"
	local set_bg_color="${csi}44m"
	local set_fg_color="${csi}30m"
	local move_cursor_to_bottom="${csi}${LINES};$((COLUMNS - ${#message}))H"

	# write the message
	printf "${save_cursor_position}"
	printf "${move_cursor_to_bottom}"
	printf "${set_bg_color}${set_fg_color}${message}${reset}"
	printf "${restore_cursor_position}"

	# clean up after 5 seconds of timeout
	function __clean_up() {
		sleep 5
		printf "${save_cursor_position}"
		printf "${move_cursor_to_bottom}"
		printf "${erase_from_cursor_to_end_of_screen}"
		printf "${restore_cursor_position}"
	}

	# clean up in the background
	# run in a subshell to avoid showing 'job control' output
	(__clean_up &)

	# clean up internal functions
	unset -f __clean_up
}

# sample function
# run this in the background with 'check_email &'
function check_email() {
	sleep 10
	write_message "You have 69 new emails (total 420 unread)"
}

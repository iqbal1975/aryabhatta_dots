#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=Yat95AAV5k4

# from https://unix.stackexchange.com/a/217390/569343
# write provided text to the terminal input
# (does not work in subshells)
# - There are some weird errors when I remove the 2>/dev/nulls, but I don't
#   even know how to begin to fix them.
function write_to_input() {
	bind '"\e[0n": "'"$*"'"'

	saved_settings=$(stty -g 2>/dev/null)
	stty -echo -icanon min 1 time 0 2>/dev/null
	printf '\e[5n'
	until read -r -t0; do
		sleep 0.02
	done
	stty "$saved_settings" 2>/dev/null
}

# Killring internal function
# - this function performs the actual job of calculating and printing the
#   killring
# - the strange name is because, due to the ungodly hack required for this
#   thing to work, there is an edge case when the kill ring is empty, in which
#   this function will be typed into the Readline input line but the user still
#   needs to press enter. Therefore the function itself acts as the
#   user-friendly message.
# - It works like this:
#   - It guesses the content of the keyring after 10 rotations, and prints it.
#   - It calculates how many times it must rotate to return to the original
#     position, and performs the rotation by editing the Readline input line.
#   - Then it preses delete 500 times, in the hope of returning the input line
#     in pristine condition.
function __Killring_is_empty__Press_enter_to_continue() {
	local array
	readarray -t array

	# if array is empty, killring is empty
	if [[ ${#array[@]} == 0 ]]; then
		return
	fi

	# the last yanked thing
	local current_position=$((${#array[@]} - 1))

	# find index of element that matches the first, or -1 if none
	# Note: this script assumns that there are no repeated elements in the
	#       killring. If that's not the case, the ring will rotate from the
	#       original position.
	#       A better algorithm to detect repeated elements could help, but I
	#       can't be arsed.
	local index_of_repeat=-1
	for ((i = 1; i < ${#array[@]}; i++)); do
		if [[ "${array[$i]}" == "${array[0]}" ]]; then
			index_of_repeat=$i
			break
		fi
	done

	# reduce array to the actual killring
	if [[ $index_of_repeat != -1 ]]; then
		array=("${array[@]:0:$index_of_repeat}")
	fi

	local killring_size="${#array[@]}"

	# print killring
	local green='\x1b[32m'
	local reset='\x1b[0m'
	clear
	echo "${green}"Killring:"${reset}"
	for ((i = 0; i < ${#array[@]}; i++)); do
		local display_index=$((i + 1))
		echo "${green}${display_index}${reset} ${array[$i]}"
	done

	local needed_pops=0
	local killring_position=$((current_position % killring_size))
	if [[ $killring_position != 0 ]]; then
		needed_pops=$((killring_size - killring_position))
	fi

	# doing the pops
	local command='\C-y'
	for ((i = 0; i < needed_pops; i++)); do
		command="$command\ey"
	done

	# append 500 backspaces to clear the input (\C-?)
	# Forgive me, Lord.
	for ((i = 0; i < 500; i++)); do
		command="$command\C-?"
	done
	write_to_input "$command"
	set -o history
}

# show the current killring
function killring() {
	set +o history

	# a killring has a maximum size of 10 in bash, so this should be enough to
	# figure out the contents
	local size=10

	# compose command to show killring.
	# - the command consists of pressing \C-y to yank 10 times to cover the
	#   entire killring.
	# - for some reason, \C-y stops the command generation if there's nothing in
	#   the killring, so we leave the command in a functional state in that
	#   situation, so that the user can press enter to proceed.
	# - Note: Your shell must be in "set -o emacs" mode for this to work. If
	#   needed you could switch to emacs here and back to vi after the command
	#   ends.
	local command="__Killring_is_empty__Press_enter_to_continue <<'EOF'\nEOF"
	command="$command\C-y\C-a\C-d\C-d\C-d\n"
	for ((i = 1; i < size; i++)); do
		command="$command\C-y\ey\n"
	done
	command="${command}EOF\n"
	write_to_input "$command"
}

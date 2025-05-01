#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/0zx4uSBUt_k

# Add this somewhere in your ~/.bashrc

# Use bash-preexec.sh (https://github.com/rcaloras/bash-preexec) to:
# - disable the Ctrl-Z keybinding before printing the prompt
# - enable the Ctrl-Z keybinding before executing a command
#
# This way, we are able to repurpose Ctrl-Z when in a Bash interactive
# prompt. But any command ran by Bash will still be able to suspend normally
# with Ctrl-Z.
#
# Note: This module requires two Bash features which you must not otherwise be
# using: the "DEBUG" trap, and the "PROMPT_COMMAND" variable. If you override
# either of these after bash-preexec has been installed it will most likely
# break.
# - I have used PROMPT_COMMAND later (as an array) without problems, but keep
# this in mind is something breaks in the future.
source ~/.local/bin/bash-preexec.sh
preexec() {
	stty susp '^Z'
}
precmd() {
	stty susp undef
}

# Ctrl-Z handler
# resume next to last suspended job.
# - If you have one job, Ctlr-Z will toggle in and out of it.
# - If you have more jobs, "Ctrl-Z Ctrl-Z" will toggle between the last two.
function ctrl_z_handler() {
	# special case: if there's one suspended job with + (last), and other jobs
	# but none with - (next to last), then switch to the first job without
	# +.
	# This is useful becuase it's an edge case that happens sometimes (when
	# closing a third program and trying to return to a state of toggling between
	# your main two)
	local jobs="$(command jobs -s)"
	local last_job="$(echo "$jobs" | sed -n 's/^\[([0-9]+)\]\+.*$/\1/p')"
	local job_with_minus="$(echo "$jobs" | sed -n 's/^\[([0-9]+)\]-.*$/\1/p')"
	local next_to_last_job="$(echo "$jobs" | sed -n 's/^\[([0-9]+)\][^+-].*$/\1/p' | tail -n 1)"

	# if jobs is empty, print error message and return
	if [[ -z "$jobs" ]]; then
		echo 'No jobs to resume.'
		return
	fi

	if [[ -n "$last_job" && -z "$job_with_minus" && -n "$next_to_last_job" ]]; then
		fg "$next_to_last_job"
	else
		# if there is a job with minus
		if [[ -n "$job_with_minus" ]]; then
			fg "$job_with_minus"
		else
			# otherwise, resume the last job
			fg "$last_job"
		fi
	fi
}

# Bind Ctrl-Z to "ctrl_z_handler" (resume next to last suspended job, or last
# if only one)
# Also, it runs Ctrl-u first, so that the command line is cleared and it
# doesn't interfere with the ctrl_z_handler.
bind -m emacs '"\C-z":"\C-uctrl_z_handler\n"'
bind -m vi '"\C-z":"\C-uctrl_z_handler\n"'
bind -m vi-insert '"\C-z":"\C-uctrl_z_handler\n"'

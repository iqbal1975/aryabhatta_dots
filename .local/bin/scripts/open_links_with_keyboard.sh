#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=z6Wee8o4x1s

# Put this in your .bashrc

# Record terminal to this file.
__terminal_recording_file="${HOME}/.cache/terminal_recording"

# Record terminal output.
# TOOD: A limitation is only one recording is done at a time.
#       This means that a new Bash session in another terminal emulator won't
#       record. (Unless it's within a terminal multiplexer spawned from the
#       same shell, which will be recorded as usual)
#       A possible workaround is to start a new recording if Bash starts on a
#       tty not currently being recorded.
function __start_recording_terminal() {
	# if the file exists, don't record, as this means that the recording is
	# already happening in the current shell.
	if [[ -f "$__terminal_recording_file" ]]; then
		return
	fi

	# save the PID of the shell that started the recording
	echo $$ >|"$__terminal_recording_file.pid"

	# Start recording, with "flushing" option to have quick access to the last
	# output, and quiet option to disable "started recording" message.
	# Also, check if script can be run with '-f' (linux) or '-F' (macOS)
	# TODO: This test might be buggy, test in Linux and make sure we are not
	#       breaking stuff.
	script -q -f /dev/null >/dev/null 2>&1
	local script_can_be_run_with_f="$?"
	if [[ "$script_can_be_run_with_f" -ne 0 ]]; then
		script -q -F "$__terminal_recording_file"
	else
		script -q -f "$__terminal_recording_file"
	fi
}
__start_recording_terminal # comment this line to disable recording

function __open_last_visible_link_in_terminal() {
	# look for the last thing that looks like a link in the last 50 lines of the
	# terminal recording (assumed to be the currently visible part of the
	# terminal)
	local link="$(tail -n 50 "$__terminal_recording_file" | tac | grep -Eo -m 1 --color=never 'https?://[[:print:]]+')"
	if [[ -z "$link" ]]; then
		echo "No link found"
		return 1
	fi

	echo "Opening link: $link"
	open "$link"
}

# Bind "Ctrl-x Ctrl-l" to "__open_last_visible_link_in_terminal" in all modes
# Also, it runs Ctrl-u first, so that the command line is cleared and it
# doesn't interfere.
bind -m emacs '"\C-x\C-l":"\C-u __open_last_visible_link_in_terminal\n"'
bind -m vi-insert '"\C-x\C-l":"\C-u __open_last_visible_link_in_terminal\n"'
bind -m vi '"\C-x\C-l":"\C-u __open_last_visible_link_in_terminal\n"'

# cleanup function on Bash exit
function __cleanup() {
	# if a recording is happening and the parent of this shell is the recording
	# command, kill the shell that started the recording and remove the files
	ps -p $PPID | grep -q 'script -q'
	is_parent_script="$?"
	if [[ -f "$__terminal_recording_file" && "$is_parent_script" -eq 0 ]]; then
		rm "$__terminal_recording_file" >/dev/null 2>&1
		local pid="$(cat "$__terminal_recording_file.pid")"
		rm "$__terminal_recording_file.pid" >/dev/null 2>&1
		kill -9 "$pid"
	fi
}
trap __cleanup EXIT

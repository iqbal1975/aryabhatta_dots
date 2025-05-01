#!/usr/bin/env bash
# Gracefully close all programs and windows running in hyprland session
#
# This script does NOT actually exit the session (hyprctl dispatch exit)!
#   Doing so would just dump us out to the login screen. (..also exiting
#   hyprland here may abort any pending async request, e.g. shutdown.)
#   The script exits after ensuring processed are terminated gracefully,
#   letting the caller decide what to do next.

# redirect stdout and stderr to file descriptors 3 and 4, then to file
exec 3>&1 4>&2 >~/tmp/hypr/hyprexitwithgrace.log 2>&1
echo "$0: Entered"
set -x
# Ensure tmux sessions are saved and exited gracefully
TMUX_SESSION=0
tmux -v set -g @continuum-save-interval '0' # disable tmux-continuum auto-saving
tmux -v send-keys -t${TMUX_SESSION} C-a C-s # save the session with tmux-resurrect
tmux -v send-keys -t${TMUX_SESSION} C-a C-x # kill the session with tmux-sessionist
sleep 2

# Batch Close All Client Windows
#   - Hyprctl processes requests synchronously, so no need to sleep after
#     - https://wiki.hyprland.org/Configuring/Using-hyprctl/#using-hyprctl
#     - https://wiki.hyprland.org/Configuring/Using-hyprctl/#batch
HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
hyprctl --batch "$HYPRCMDS"

# TODO: un-inhibit systemd-logind's handling of power events since we customize this using acpid

# Wait until there are no processes whose full cmdline matches any of the following names
PROC_NAMES_TO_WAIT_FOR=(brave chrome chromium discord firefox gimp obsidian sidekick slack thorium)
# Mask pwait exit code 1 which means there were no matching processes to wait for
if pwait -fi "$(
	IFS=\|
	echo "${PROC_NAMES_TO_WAIT_FOR[*]}"
)" || [ $? -eq 1 ]; then
	[[ "$*" =~ .*(--poweroff|-p).* ]] && systemctl poweroff
	[[ "$*" =~ .*(--reboot|-r).* ]] && systemctl reboot
	RET=0
else
	RET=$?
	echo "ERROR: Error $RET waiting for processes ${PROC_NAMES_TO_WAIT_FOR}"
fi

echo "$0: Exiting.."
# restore stdout and stderr
exec 2>&3 2>&4 exit $RET

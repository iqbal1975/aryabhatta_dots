#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=yYsmcfWIblg

# Add this somewhere in ~/.bashrc

# __edit_without_executing
# - Replacement for the "C-x e" Bash binding, but without executing the
#   command immediately. (Good for validating before running, and for performing
#   history expansion).
__edit_without_executing() {
	local editor="${EDITOR:-nano}"
	local tmpf="$(mktemp)"
	printf '%s\n' "$READLINE_LINE" >|"$tmpf"
	"$editor" "$tmpf"
	READLINE_LINE="$(<"$tmpf")"
	READLINE_POINT="${#READLINE_LINE}"
	rm -f "$tmpf" >/dev/null 2>&1
}

# bind to "C-x e" in all modes
bind -m vi -x '"\C-x\C-e":__edit_without_executing'
bind -m vi-insert -x '"\C-x\C-e":__edit_without_executing'
bind -m emacs -x '"\C-x\C-e":__edit_without_executing'

# bind to "v" in vi normal mode
bind -m vi -x '"v":__edit_without_executing'

# bind to "alt-v" in vi insert mode
bind -m vi-insert -x '"\ev":__edit_without_executing'

#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=ISKzBlzXRWE

# get the texinfo node for a command
# - takes a command name, like 'cat'
# - if it belongs to a texinfo node, returns the node name, like 'coreutils'
# - otherwise returns empty string
function __get_texinfo_node_for_command() {
	local coreutils_commands=(
		'cat' 'tac' 'nl' 'od' 'base32' 'base64' 'base64' 'basenc'
		'fmt' 'pr' 'fold'
		'head' 'tail' 'split' 'csplit'
		'wc' 'sum' 'cksum' 'b2sum' 'md5sum' 'sha1sum'
		'sha224sum' 'sha256sum' 'sha384sum' 'sha512sum'
		'sort' 'shuf' 'uniq' 'comm' 'ptx' 'tsort' 'ptx'
		'cut' 'paste' 'join'
		'tr' 'expand' 'unexpand'
		'ls' 'dir' 'vdir' 'dircolors'
		'cp' 'dd' 'install' 'mv' 'rm' 'shred'
		'link' 'ln' 'mkdir' 'mkfifo' 'mknod' 'readlink' 'rmdir' 'unlink'
		'chown' 'chgrp' 'chmod' 'touch'
		'df' 'du' 'stat' 'sync' 'truncate'
		'echo' 'printf' 'yes'
		'false' 'true' 'test' 'expr' 'tee'
		'basename' 'dirname' 'pathchk' 'mktemp' 'realpath'
		'pwd' 'stty' 'printenv' 'tty'
		'id' 'logname' 'whoami' 'groups' 'users' 'who'
		'arch' 'date' 'nping' 'uname' 'hostname' 'hostid' 'uptime'
		'chcon' 'runcon'
		'chroot' 'env' 'nice' 'nohup' 'stdbuf' 'timeout'
		'kill' 'sleep'
		'factor' 'numfmt' 'seq'
	)

	local bash_builtins=(
		'.' ':' '[' 'alias' 'bg' 'bind' 'break' 'builtin' 'caller' 'cd' 'command'
		'compgen' 'complete' 'compopt' 'continue' 'declare' 'dirs' 'disown' 'echo'
		'enable' 'eval' 'exec' 'exit' 'export' 'false' 'fc' 'fg' 'getopts' 'hash'
		'help' 'history' 'jobs' 'kill' 'let' 'local' 'logout' 'mapfile' 'popd'
		'printf' 'pushd' 'pwd' 'read' 'readarray' 'readonly' 'return' 'set'
		'shift' 'shopt' 'source' 'suspend' 'test' 'times' 'trap' 'type' 'typeset'
		'ulimit' 'umask' 'unalias' 'unset' 'wait'

		# and some reserved words too:
		'!' # this represents pipelines
		'[[' '{' 'case' 'if' 'for' 'function' 'select' 'time' 'until' 'while'
	)

	for cmd in "${bash_builtins[@]}"; do
		if [[ "$1" == "$cmd" ]]; then
			echo 'bash'
			return 0
		fi
	done
	for cmd in "${coreutils_commands[@]}"; do
		if [[ "$1" == "$cmd" ]]; then
			echo 'coreutils'
			return 0
		fi
	done

	echo ''
	return 0
}

# custom info
# - prepend 'coreutils' if argument is a coreutils command
# - prepend 'bash' if argument is a bash builtin
# - add some default options
function info() {
	# if there is only one non-option argument, and it matches a coreutils or
	# bash builtin, prepend the corresponding name
	local option_args=()
	local non_option_args=()
	for arg in "$@"; do
		if [[ ! "$arg" =~ ^- ]]; then
			non_option_args+=("$arg")
		else
			option_args+=("$arg")
		fi
	done
	if [[ "${#non_option_args[@]}" -eq 1 ]]; then
		info_node="$(__get_texinfo_node_for_command "${non_option_args[0]}")"
		if [[ -n "$info_node" ]]; then
			non_option_args=("${info_node}" "${non_option_args[@]}")
		fi
	fi

	# add default options and run
	option_args+=('--vi-keys' '--init-file' "${XDG_CONFIG_HOME}/infokey")
	command info "${option_args[@]}" "${non_option_args[@]}"
}
alias i="info"

# custom man
# - if receiving a command with info page, run info instead
function man() {
	if [[ "$#" -eq 1 && $(__get_texinfo_node_for_command "$1") != '' ]]; then
		info "$1"
	else
		command man "$@"
	fi
}
alias m="man"

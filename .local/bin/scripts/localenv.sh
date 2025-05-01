#! /usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# put this in your .bashrc or something like that

# localenv
# print only the environment variables that were added
# since the shell was started
function localenv() {
	# this is done by comparing the output of 'set' in the current
	# shell with the output of 'set' in a new shell.
	# A custom sed command excludes the variables that are always
	# different between shells (like PPID, SHELLOPTS, etc.), including
	# the ones defined in this function.
	local localenv_exclude=('BASH_EXECUTION_STRING' 'BASHOPTS' 'HISTFILESIZE'
		'HISTSIZE' 'PIPESTATUS' 'PPID' 'SHELLOPTS' 'SHLVL' '^_' 'BASH_ARGC' 'BASH'
		'ARGV' 'BASH_LINENO' 'BASH_SOURCE' 'FUNCNAME' 'localenv_exclude' 'localenv_exclude_sed')

	# prepend '^' and append '=' to each element, join with '|',
	# wrap in '/' and '/d'
	localenv_exclude=("${localenv_exclude[@]/#/^}")
	localenv_exclude=("${localenv_exclude[@]/%/=}")
	local localenv_exclude_sed=$(
		IFS="|"
		echo "${localenv_exclude[*]}"
	)
	localenv_exclude_sed="/$localenv_exclude_sed/d"

	command diff <(set | sed -E "$localenv_exclude_sed") \
		<(bash -i -c set | sed -E "$localenv_exclude_sed") |
		sed -nE 's/^< (.*)/\1/p'
}

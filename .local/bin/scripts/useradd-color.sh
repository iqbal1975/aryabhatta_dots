#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

### Make sure this file is visible from your $PATH and called 'useradd'

# Video demo: https://www.youtube.com/watch?v=Nzl2YzYDFlI

### Sample output:
#
# CREATE_HOME        no
# CREATE_MAIL_SPOOL  no
# LOG_INIT           yes
# USERGROUPS_ENAB    yes
# HOME               /home
# MAIL_DIR           /var/spool/mail
# MAIL_FILE          N/A
# SHELL              /bin/bash
# SKEL               /etc/skel
# EXPIRE             N/A
# GROUP              984 (users)
# INACTIVE           -1
# PASS_MAX_DAYS      99999
# PASS_MIN_DAYS      0
# PASS_WARN_AGE      7
# UMASK              077
# -------------------------------------------------------------------------------------
# CREATE_HOME:       Create a home directory if it does not exist.
# CREATE_MAIL_SPOOL: Create a mailbox file for the user.
# LOG_INIT:          Add the user to the lastlog and faillog databases.
# USERGROUPS_ENAB:   If set to yes, useradd will create a group with the name of the
#                    user, and userdel will remove the user's group if it contains no
#                    more members.
# HOME:              The user's name will be affixed to form the new home.
# MAIL_DIR:          The mail spool file will be created using this value.
# MAIL_FILE:         Same, but relative to the user's home directory.
# SHELL:             The user's login shell.
# SKEL:              The skeleton directory, which contains files and directories to
#                    be copied into the user's home directory.
# EXPIRE:            The date on which the user account will be disabled, if any.
# GROUP:             If USERGROUPS_ENAB is set to no, or if the flag -N/--no-user-group
#                    is passed, this will be the new user's group.
# INACTIVE:          The number of days after a password has expired in which the
#                    password is still be accepted. -1 disables the inactive period.
# PASS_MAX_DAYS:     The number of days a password may be used. If is older, a password
#                    change will be forced.
# PASS_MIN_DAYS:     The minimum number of days allowed between password changes. Any
#                    attempt sooner will be rejected.
# PASS_WARN_AGE:     Warn user N days befere password expiration.
# UMASK:             The file mode creation mask is initialized to this value.

# custom useradd
# - add color when called with only -D or --defaults
# - add footer

green='\x1b[32m'
red='\x1b[31m'
cyan='\x1b[36m'
bold='\x1b[1m'
reset='\x1b[0m'

if [[ "$#" -eq 1 && ("$1" == "-D" || "$1" == "--defaults") ]]; then
	# from /etv/login.defs, get lines with variables relevant to useradd
	declare -a logindefsvars=("CREATE_HOME" "MAIL_DIR" "MAIL_FILE"
		"PASS_MAX_DAYS" "PASS_MIN_DAYS" "PASS_WARN_AGE" "UMASK" "USERGROUPS_ENAB")
	joinedvars=$(echo "${logindefsvars[@]}" | tr ' ' '|')
	logindefs=$(
		cat '/etc/login.defs' |
			sed -E -n -e '/^('"$joinedvars"')/ {s/[[:blank:]]+/=/g ; p}'
	)

	# if any of the variables are not defined, add them as 'VARNAME='
	for var in "${logindefsvars[@]}"; do
		if ! echo "$logindefs" | grep -q "^$var="; then
			logindefs+=$'\n'
			logindefs+="$var="
		fi
	done

	# as an extra help, we now that 'CREATE_HOME=' is the same as 'CREATE_HOME=no'
	# so we make it explicit
	logindefs=$(echo "$logindefs" | sed -E -e 's/^CREATE_HOME=$/CREATE_HOME=no/g')

	# concatenate with output os useradd -D
	output=$(/usr/bin/useradd -D)
	output+=$'\n'
	output+="$logindefs"

	# sort output
	output=$(echo "$output" | sort)
	# put boolean values first, then values with
	# paths, then the rest
	booleanoutput=$(echo "$output" | sed -E -n -e '/yes|no/ {p}')
	pathoutput=$(echo "$output" | sed -E -n -e '/^(HOME|MAIL_DIR|MAIL_FILE|SHELL|SKEL)=/ {p}')
	otheroutput=$(echo "$output" | sed -E -n -e '/^(HOME|MAIL_DIR|MAIL_FILE|SHELL|SKEL)=|yes|no/ ! {p}')
	output=$(echo -e "$booleanoutput\n$pathoutput\n$otheroutput")

	# append group name to group number
	groupnumber=$(echo "$output" | sed -E -n -e 's/^GROUP=//p')
	groupname=$(getent group "$groupnumber" | cut -d: -f1)
	output=$(echo "$output" | sed -E -e 's/^GROUP=[0-9]+/GROUP='"$groupnumber"' ('"$groupname"')/g')

	# replace = with tab. add color. Print "N/A" if empty value.
	echo "$output" |
		sed -E -e 's/(.+)=(.+)/'"${green}"'\1'"${reset}"'\t\2/g' \
			-e 's/(.+)=$/'"${green}"'\1'"${reset}"'\t'"${cyan}"'N\/A'"${reset}"'/g' \
			-e 's/yes/'"${green}"'yes'"${reset}"'/g' \
			-e 's/no/'"${red}"'no'"${reset}"'/g' |
		column -t -s $'\t'

	# print info footer
	info_footer="-------------------------------------------------------------------------------------\n"
	info_footer+="${cyan}CREATE_HOME${reset}:       Create a home directory if it does not exist.\n"
	info_footer+="${cyan}CREATE_MAIL_SPOOL${reset}: Create a mailbox file for the user.\n"
	info_footer+="${cyan}LOG_INIT${reset}:          Add the user to the lastlog and faillog databases.\n"
	info_footer+="${cyan}USERGROUPS_ENAB${reset}:   If set to ${green}yes${reset}, ${bold}useradd${reset} will create a group with the name of the\n"
	info_footer+="                   user, and ${bold}userdel${reset} will remove the user's group if it contains no\n"
	info_footer+="                   more members.\n"
	info_footer+="${cyan}HOME${reset}:              The user's name will be affixed to form the new home.\n"
	info_footer+="${cyan}MAIL_DIR${reset}:          The mail spool file will be created using this value.\n"
	info_footer+="${cyan}MAIL_FILE${reset}:         Same, but relative to the user's home directory.\n"
	info_footer+="${cyan}SHELL${reset}:             The user's login shell.\n"
	info_footer+="${cyan}SKEL${reset}:              The skeleton directory, which contains files and directories to\n"
	info_footer+="                   be copied into the user's home directory.\n"
	info_footer+="${cyan}EXPIRE${reset}:            The date on which the user account will be disabled, if any.\n"
	info_footer+="${cyan}GROUP${reset}:             If ${bold}USERGROUPS_ENAB${reset} is set to ${red}no${reset}, or if the flag ${bold}-N/--no-user-group${reset}\n"
	info_footer+="                   is passed, this will be the new user's group.\n"
	info_footer+="${cyan}INACTIVE${reset}:          The number of days after a password has expired in which the\n"
	info_footer+="                   password is still be accepted. -1 disables the inactive period.\n"
	info_footer+="${cyan}PASS_MAX_DAYS${reset}:     The number of days a password may be used. If is older, a password\n"
	info_footer+="                   change will be forced.\n"
	info_footer+="${cyan}PASS_MIN_DAYS${reset}:     The minimum number of days allowed between password changes. Any\n"
	info_footer+="                   attempt sooner will be rejected.\n"
	info_footer+="${cyan}PASS_WARN_AGE${reset}:     Warn user N days befere password expiration.\n"
	info_footer+="${cyan}UMASK${reset}:             The file mode creation mask is initialized to this value.\n"
	echo -e "$info_footer"

else
	/usr/bin/useradd "$@"
fi

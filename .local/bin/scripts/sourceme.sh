#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=cOYVjk26504

red="\e[31m"
green="\e[32m"
reset="\e[0m"

# Check if script is sourced.
# https://stackoverflow.com/a/28776166/21567639
(return 0 2>/dev/null) && sourced=true || sourced=false

# Exit if script is not sourced.
if [[ ${sourced} == false ]]; then
	echo -e "${red}Error:${reset} This script cannot be executed directly, it must be sourced.\n"
	echo -e "Try running"
	echo -e "${green}source ${0}${reset}"
	echo -e "or"
	echo -e "${green}. ${0}${reset}"
	exit 1
fi

### Put your code here ###

# Note: Naturally, you can "chmod -x" the file instead to make it
# non-executable and still sourceable. But I follow the philosophy of "shoot
# first, ask questions later", meaning that any file that the user interacts
# with must be self documenting, and executing it provides the documentation.

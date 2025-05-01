#!/usr/bin/env bash

# Video demo: N/A (This script is so dank that YouTube took down my video without explanation)

# Add this to your ~/.bashrc

# custom fc-list
# - sort list
# - add color
# - format table output
function fc-list() {
	# if calling with arguments, call the original command
	if [[ "$#" -gt 0 ]]; then
		command fc-list "$@"
		return $?
	fi

	# prepend header
	{
		echo "FILE:FAMILY:STYLE"
		command fc-list "$@" | sort
	} |
		# replace space after colon after file name
		sed -E 's/: /:/g' |

		# pretty print the file path
		command awk -F: '
  BEGIN {
    green="\033[32m";
    white="\033[0m";
    bold="\033[1m";
    reset="\033[0m";
  }
  function pretty_print_directory(path) {
    last_slash = match(path, /\/[^\/]+$/);
    directory = substr(path, 1, last_slash);
    file = substr(path, last_slash + 1);

    # print the directory in green, and the file in white and bold
    return green directory white bold file reset;
  }
  {
    # skip header row, but make every field bold
    if (NR == 1) {
      OFS=":";
      for (i = 1; i <= NF; i++) {
        $i = bold $i reset;
      }
      print $0;
      next;
    }
    OFS=":";
    $1 = pretty_print_directory($1);

    # remove "style=" prefix from 3rd field
    sub(/^style=/, "", $3);

    # if fiels consist of 3+ comma separated values, print only the first
    # two followed by "..."
    $2 = gensub(/^([^,]+,[^,]+).*/, "\\1, ...", 1, $2);
    $3 = gensub(/^([^,]+,[^,]+).*/, "\\1, ...", 1, $3);

    print $0;
  }' |
		column -t -s: |
		less -S
}
alias fonts="fc-list"

# fc-list-families
# - list only the font families in the system
function fc-list-families() {
	command fc-list : family | sort
}
alias fontfamilies="fc-list-families"

#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/9dU44VdoGIo

# custom bind
# - color and table formatting for "-V" and "-P"
# - if using vi mode, print both "normal" and "insert" keybindings
# - print keybindings for all keymaps if "-a" is present
function bind() {
	if [[ "$#" == 1 && "$1" == "-V" ]]; then
		command bind -V | command awk '
      BEGIN {
        green = "\033[32m";
        red = "\033[31m";
        cyan = "\033[96m";
        reset = "\033[0m";
      }
      {
        $NF = gensub(/^.?(on).?$/, green "\\1" reset, "g", $NF);
        $NF = gensub(/^.?(off).?$/, red "\\1" reset, "g", $NF);
        if (substr($NF, 1, 1) == "`") {
          $NF = substr($NF, 2, length($NF) - 2);
        }
        print $1 "\t" $NF;
      }' | column -t
	elif [[ "$@" =~ "-P" ]]; then
		# if "-a" is present, print keybindings for all keymaps
		if [[ "$@" =~ "-a" ]]; then
			cyan='\x1b[96m'
			reset='\x1b[0m'

			{
				bind -P -m emacs | sed 's/^/'"${cyan}"'emacs:'"${reset}"'/'
				bind -P -m vi | sed 's/^/'"${cyan}"'vi-normal:'"${reset}"'/'
				bind -P -m vi-insert | sed 's/^/'"${cyan}"'vi-insert:'"${reset}"'/'
			} |
				# replace first sequence of spaces with a tab to normalize the output
				command sed -E 's/^([^[:space:]]+)([[:space:]]+)/\1\t/' | column -t -s $'\t'
			return
		fi

		# if "-P" is the only option, and vi mode is on, print keybindings for both
		# vi-normal and vi-insert
		if [[ -o vi && "$#" == 1 && "$1" == "-P" ]]; then
			cyan='\x1b[96m'
			reset='\x1b[0m'

			{
				bind -P -m vi | sed 's/^/'"${cyan}"'vi-normal:'"${reset}"'/'
				bind -P -m vi-insert | sed 's/^/'"${cyan}"'vi-insert:'"${reset}"'/'
			} |
				# replace first sequence of spaces with a tab to normalize the output
				command sed -E 's/^([^[:space:]]+)([[:space:]]+)/\1\t/' | column -t -s $'\t'
			return
		fi

		command bind "$@" | command awk '
      BEGIN {
        green = "\033[32m";
        red = "\033[31m";
        cyan = "\033[96m";
        reset = "\033[0m";
      }
      {

        keys = "";
        # if line contains text "can be found on", the keys is everything after it
        if ($0 ~ /can be found on/) {
          keys = substr($0, index($0, "can be found on") + 15);

          # add a space between a double quote and a comma
          keys = gensub(/",/, "\" ,", "g", keys);

          # for every text within double quotes in keys, make the text inside
          # the quotes cyan, and preserve the quotes
          keys = gensub(/"([^"]+)"/, "\"" cyan "\\1" reset "\"", "g", keys);

          # remove trailing dot on keys, unless the last value is "..."
          if (substr(keys, length(keys) - 2) != "...") {
            keys = substr(keys, 1, length(keys) - 1);
          }

        }

        # it there are keys, make $1 green
        if (keys != "") {
          $1 = green $1 reset;
        }

        print $1 "\t" keys;
      }' | column -t -s $'\t'
	else
		command bind "$@"
	fi
}

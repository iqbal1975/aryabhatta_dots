#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/shorts/7rEHZPfJwYU

# custom stty
# - color and table formatting
function stty() {
	# only proceed if called with:
	# - no arguments
	# - only -a
	# - only -F device/--file=device
	# - -a, and also -f device/--file=device. in any order.
	if [[ $# -eq 0 ]] || [[ $# -eq 1 && "$1" = "-a" ]] ||
		[[ $# -eq 2 && ("$1" = "-F" || "$1" = "--file="*) ]] ||
		[[ $# -eq 3 && "$1" = "-a" && ("$2" = "-F" || "$2" = "--file="*) ]] ||
		[[ $# -eq 3 && ("$1" = "-F" || "$1" = "--file="*) && "$3" = "-a" ]]; then
		command stty "${@}" | command awk '
      BEGIN {
        green = "\033[32m";
        red = "\033[31m";
        cyan = "\033[96m";
        reset = "\033[0m";

        customValues["^cs[5-8]"] = "character-size";
        customValues["^nl[01]"] = "nl-delay-style";
        customValues["^cr[0-3]"] = "cr-delay-style";
        customValues["^tab[0-3]"] = "tab-delay-style";
        customValues["^bs[01]"] = "bs-delay-style";
        customValues["^vt[01]"] = "vtab-delay-style";
        customValues["^ff[01]"] = "ff-delay-style";
      }
      NR==1 {
        # if line only contain bauds ("stty" output)
        if ($0 ~ /baud;$/) {
          print gensub(/(speed) ([0-9]+) baud;/,
            "\\1\t\\2-baud", "g", $0);
        } else {
          # else ("stty -a" output)
          print gensub(/(speed) ([0-9]+) baud; (rows) ([0-9]+); (columns) ([0-9]+);/,
            "\\1\t\\2-baud\n\\3\t\\4\n\\5\t\\6", "g", $0);
        }
      }
      /=/ {
        FS=";";
        $0=$0;
        for (i=1; i<=NF; i++) {
            if ($i == "") continue;
            sub(/^[ ]+/, "", $i);
            split($i, a, " = ");

            # if the name is not "min" or "time", add color to value because it is
            # a character
            if (a[1] != "min" && a[1] != "time") {
              a[2] = cyan a[2] reset;
            }

            print a[1] "\t" a[2];
        }
      }
      # match the rest
      !/=/ && NR!=1 {
        FS=" ";
        $0=$0;
        for (i=1; i<=NF; i++) {
          # if field starts with -, it is off
          if (substr($i, 1, 1) == "-") {
            print substr($i, 2) "\t" red "off" reset;
          } else {
            # if field is a custom value
            isCustom = 0;
            for (custom in customValues) {
              if ($i ~ custom) {
                print customValues[custom] "\t" $i;
                isCustom = 1;
                break;
              }
            }

            if (!isCustom) {
              print $i "\t" green "on" reset;
            }
          }
        }
      }' | column -t -s $'\t'
	else
		command stty "$@"
	fi
}

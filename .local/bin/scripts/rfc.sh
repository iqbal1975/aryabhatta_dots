#!/usr/bin/env bash

# All my gist code is licensed under the MIT license.

# Video demo: https://www.youtube.com/watch?v=Ypqf2IFc62I

# rfc
# - fetches and renders an RFC into less
# - from www.rfc-editor.org
# - if called with -l/--list, lists all RFCs in descending order
function rfc() {
	# print usage if no arguments
	if [[ $# -eq 0 ]]; then
		echo "Usage: rfc <rfc-number>" >&2
		echo "       rfc -l/--list  (lists all RFCs in descending order)" >&2
		return 1
	fi

	if [[ "$1" == "-l" || "$1" == "--list" ]]; then
		local index_url="https://www.rfc-editor.org/rfc-index.txt"
		local index_file="/tmp/rfc/index.txt"

		# if not cached, download it with curl
		if [[ ! -f "${index_file}" ]]; then
			mkdir -p /tmp/rfc >/dev/null
			curl -s "${index_url}" -o "${index_file}"
			if [[ $? -ne 0 ]]; then
				echo "Error: Could not download RFC index file" >&2
				return 1
			fi
		fi

		# parse every group of lines beginning ith 'XXXX' and ending with an empty line
		# save them to an arrray, print them in reverse order, add color and formatting
		command awk '
    BEGIN {
      green="\033[32m";
      white="\033[0m";
      bold="\033[1m";
      reset="\033[0m";

      # define the array to contain the RFCs
      rfc_array_index = 0
    }
    {
      # if the line begins with "XXXX", add line plus lines until first empty line to array as a single string
      if ($0 ~ /^[0-9]+/) {
        description = $0
        while (getline > 0) {
          if ($0 == "") {
            break
          }
          line = $0
          description = description "\n" line
        }

        # remove newlines, remove consecutive spaces
        description = gensub(/\n/, " ", "g", description)
        description = gensub(/  */, " ", "g", description)

        # move parenthesis text "(Category: value)" to its own line (prepend newline and 5 spaces)
        # make sure that regex is not greedy to avoid matching multiple parenthesis
        description = gensub(/(\(([^\):]+:|Also|Updates|Obsoletes) [^\)]+\))/, "\n     \\1", "g", description)

        # move authors to new line
        description = gensub(/( [A-Z]\. )/, "\n    \\1", 1, description)

        # make number green, and the rest of first line bold
        description = gensub(/^([0-9]+) (.*)$/, green "\\1" white " " bold "\\2" reset, 1, description)

        rfc_array[++rfc_array_index] = description
        # print rfc_array_index
        # print rfc_array[rfc_array_index]
      }
    }
    END {
      # print the array in reverse order
      for (i = rfc_array_index; i > 0; i--) {
        print rfc_array[i]
      }
    }' "${index_file}" | less
		return 0
	fi

	local rfc_number="$1"
	local rfc_url="https://www.rfc-editor.org/rfc/rfc${rfc_number}.txt"
	local rfc_file="/tmp/rfc/${rfc_number}.txt"

	# if not cached to temporary folder, download it with curl
	if [[ ! -f "${rfc_file}" ]]; then
		mkdir -p /tmp/rfc >/dev/null
		curl -s "${rfc_url}" -o "${rfc_file}"
		if [[ $? -ne 0 ]]; then
			echo "Error: Could not download RFC ${rfc_number}" >&2
			return 1
		fi
	fi

	# render it
	less "${rfc_file}"
}

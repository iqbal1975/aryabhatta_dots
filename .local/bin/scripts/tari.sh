#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=IyzNz1uPEGg

# deleteAllButMostRecentInTar
# source: https://stackoverflow.com/a/71666950/21567639
function deleteAllButMostRecentInTar() {
	local archive=$1
	local filesToDelete=$(mktemp)
	local shouldPrintMessage=true

	while true; do
		command tar --list --file "$archive" | sort | uniq -c |
			command sed -n -E '/^[ \t]*1 /d; s|^[ \t]*[0-9]+ ||p' >|"$filesToDelete"
		if [[ -s "$filesToDelete" ]]; then
			if [[ $shouldPrintMessage == true ]]; then
				echo "Found files in archive with multiple versions:"
				cat -- "$filesToDelete"
				shouldPrintMessage=false
				echo "Deleting all but most recent version..."
			fi
			local fileCount=$(cat -- "$filesToDelete" | wc -l)
			tar --delete --occurrence=1 --files-from="$filesToDelete" \
				--file "$archive"
		else
			break
		fi
	done
	if [[ -s "$filesToDelete" ]]; then
		echo "Done."
	fi
	rm -- "$filesToDelete" >/dev/null 2>&1
}

# tar "in-place"
# - an inconvenient feature of tar is that it never overwrites members with the
#   same name, meaning that operations like --append and --update will not
#   replace an existing member with a file of the same name.
# - tar "in-place" is a wrapper around tar that calls
#   deleteAllButMostRecentInTar after every tar operation
function tari() {
	tar "$@"

	# First we must figure out the archive name. Possible formats are:
	# -XXXf <archive>
	# --file=<archive>
	# Note: Old-style tar option (tar cf <archive>) is not supported because it
	# is bonkers.
	local archive_name
	if [[ "$@" =~ -[a-zA-Z0-9]*f[[:space:]]+([^[:space:]]+) ]]; then
		archive_name="${BASH_REMATCH[1]}"
	elif [[ "$@" =~ --file=([^[:space:]]+) ]]; then
		archive_name="${BASH_REMATCH[1]}"
	fi

	# If the archive is compressed, do nothing. (the tar operations that modify
	# archives don't work on compressed archives)
	if [[ "$archive_name" =~ \.(gz|bz2|xz|Z|zst)$ ]]; then
		return
	fi

	if [[ -n "$archive_name" ]]; then
		deleteAllButMostRecentInTar "$archive_name"
	fi
}

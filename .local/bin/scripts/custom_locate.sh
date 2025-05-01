#!/usr/bin/env bash

# All my gist code is licensed under the terms of the MIT license.

# Video demo: https://www.youtube.com/watch?v=KFtZbsSG_fA

# add this to your ~/.bashrc or something like that

# alias for every locate database
alias locate="glocate --regextype=posix-extended --database=${HOME}/tmp/locatedb-min"
alias locatehome="glocate --regextype=posix-extended --database=${HOME}/tmp/locatedb-home"
alias locateall="glocate --regextype=posix-extended --database=${HOME}/tmp/locatedb"
alias loc="locate"
alias loch="locatehome"
alias loca="locateall"

# custom updatedb
# - create:
#   - locatedb (all files)
#   - locatedb-home (home directory)
#   - locatedb-min (home directory, but excluding hidden files and notoriously
#     huge and useless folders)
# - TODO: Move this to a cron job
# - Note: For the regex in --prunepaths to work, manually change the source for
#         GNU updatedb as described here:
#         https://savannah.gnu.org/bugs/?19374#comment5
function updatedb() {
	echo "generating locatedb..."
	sudo updatedb --output=${HOME}/tmp/locatedb --prunepaths='/Volumes /System'

	echo "generating locatedb-home..."
	sudo updatedb --output=${HOME}/tmp/locatedb-home --localpaths="${HOME}"

	echo "generating locatedb-min..."
	sudo updatedb --output=${HOME}/tmp/locatedb-min --localpaths="${HOME}" --prunepaths="${HOME}/Library .*/\..*"
}

#!/usr/bin/env bash

###
# Adapted form here
# https://github.com/miroslavvidovic/rofi-scripts
###

# Import Current Theme
DIR="$HOME/.config/hypr"
RASI="$DIR/rofi/web-search.rasi"

declare -A URLS

URLS=(
	["Arch Wiki"]="https://wiki.archlinux.org/title/"
	["Bing"]="https://www.bing.com/search?q="
	["Brave Search"]="https://search.brave.com/search?q="
	["DuckDuckGo"]="https://www.duckduckgo.com/?q="
	["Github"]="https://github.com/search?q="
	["Gitlab"]="https://gitlab.com/search?q="
	["GoodReads"]="https://www.goodreads.com/search?q="
	["Google"]="https://www.google.com/search?q="
	["IMDB"]="http://www.imdb.com/find?ref_=nv_sr_fn&q="
	["RottenTomatoes"]="https://www.rottentomatoes.com/search/?search="
	["Stackoverflow"]="http://stackoverflow.com/search?q="
	["YouTube"]="https://www.youtube.com/results?search_query="
)

# List for rofi
gen_list() {
	for i in "${!URLS[@]}"; do
		echo "$i"
	done
}

main() {
	# Pass the list to rofi
	platform=$( (gen_list) | rofi -dmenu -theme $RASI -matching fuzzy -no-custom -location 0 -p "Search Engine List > ")
	# platform=$( (gen_list) | tofi --prompt-text "Search > ")

	if [[ -n "$platform" ]]; then
		query=$( (echo) | rofi -dmenu -theme $RASI -matching fuzzy -location 0 -p "Query >> $platform > ")
		# query=$( (echo) | tofi --prompt-text "Query > ")

		if [[ -n "$query" ]]; then
			url=${URLS[$platform]}$query
			xdg-open "$url"
		else
			exit
		fi

	else
		exit
	fi
}

main

exit 0

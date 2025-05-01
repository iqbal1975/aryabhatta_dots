#!/usr/bin/env bash

# WIOBE Index - Memeing the TIOBE Index since June 2023
# - A measure of popularity of programming languages by their Wikipedia page size (in kilobytes)
# - Find the WIOBE Index here: https://gist.github.com/sebastiancarlos/4940d24af353fdf3a2f59aed49314048

# Blocklist: a list of programming languages that we dont want to include
# - because their linked wikipedia page is not actually for the language itself but for the platform that includes it.
# - because they are duplicates from other language with the same page.
# - because they are not programming languages.
blocklist=(
	"LSL"          # Second Life scripting language
	"UnrealScript" # Unreal Engine scripting language
	"OpenCL"       # Close call, but technically not a programming language
	"Winbatch"
	"JASS" # Warcraft III scripting language
	"Apex (Salesforce.com Inc)"
	"Pike" # MUD language
	"Easy PL/I"
	"Viper (Ethereum/Ether (ETH))"
	"Vim script"
	"Serpent" # Ethereum
	"Mutan"
	"LLL" # Ethereum
	"S2"  # LiveJournal, lol what am I doing with my life?
	"GOTRAN (IBM 1620)"
	"QPL" # Quantum programming
	"Legoscript"
	"X++ (X plus plus/Microsoft Dynamics AX)"
	"GDScript (Godot)"
	"NXT-G" # Scripting language for Lego. Damn...
	"SAS"
	"App Inventor for Android's visual block language (MIT App Inventor)"
	"LilyPond"
	"dBase"
	"ObjectLOGO"
	"Processing.js"
	"Game Maker Language"
	"RPG"
	"Esoteric programming language"
)

# get html of wikipedia page for "list of all programming languages", save it to
# raw_list.html
curl https://en.wikipedia.org/wiki/List_of_programming_languages |
	tee raw_list.html |
	sed -E '
# delete lines outside of "A" and "Z" headers
/id="A"/,/id="See_also"/! d

# delete lines without <a> tag
/<a/! d

# delete second <a> tag in line. its not what we want
s/.*(<a.*)<a.*/\1/

# capture name and link of first a tag, make it absolute link
s|.*<a href="([^"]*)"[^>]*>([^<]*)</a>.*|\2,https://en.wikipedia.org\1|

# if first field (name) contains a comma, remove it. run twice to catch up to
# two extra commas
s|(.*),(.*),(.*)|\1\2,\3|
s|(.*),(.*),(.*)|\1\2,\3|

# exclude lines whose link dont start with "/wiki/"
\|.*,https://en.wikipedia.org/wiki/|! d
' >list.csv

# ^ I could have used an HTML parser but I'm fucking HARDCORE!

# get list of esoteric languages too, concatenate to list.csv
curl https://en.wikipedia.org/wiki/Category:Esoteric_programming_languages |
	tee eso_list.html |
	sed -E '
/<li>.*<a href="/! d
/id="catlinks"/ d
s|.*<a href="([^"]*)"[^>]*>([^<]*)</a>.*|\2,https://en.wikipedia.org\1|
' >>list.csv

# remove blocklisted languages
for lang in "${blocklist[@]}"; do
	sed -i '\|^'"$lang"',|d' list.csv
done

# create folder "languages"
mkdir -p languages

# iterate over csv, create file langauges/<language-name>.html, save html of
# wikipedia page. Using GNU Parallel to speed up the process, motherfuckers!
# I AM BECOME DEATH, DESTROYER OF CPUs!
get_html() {
	# get name and link. replace "/" with "_" in name because we are creating
	# files, baby!
	name=$(echo $1 | sed -E 's/(.*),.*/\1/ ; s|/|_|g')
	link=$(echo $1 | sed -E 's/.*,(.*)/\1/')

	# exit if file already exists and is not empty
	if [ -s languages/"$name".html ]; then
		return
	fi

	dest="languages/$name.html"
	echo "$name - $link ----> $dest"
	curl "$link" >"$dest"
}
export -f get_html
cat list.csv | parallel -j 10 get_html {}

# generate results.csv, get file size in kilobytes
while read -r line; do
	name=$(echo $line | sed -E 's/(.*),.*/\1/ ; s|/|_|g')
	size=$(du -k "languages/$name.html" | sed -E 's/([0-9]+).*/\1/')
	echo "$size,$line"
done <list.csv >results.csv

# sort by file size, in place
sort -rn results.csv -o results.csv

# prepend header to csv
sed -i '1i Size of Wikipedia Page (Kilobytes),Programming Language,Wikipedia Page Link' results.csv

# print results
cat results.csv

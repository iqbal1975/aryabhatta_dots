#!/usr/bin/env bash

# All my gist code is licensed under the MIT license.

# Video demo: https://www.youtube.com/watch?v=2tRyBQqJdrc

# Note: In some browsers you need to type "g/" instead of just "g" so it gets
# recognized as a URL and not as a term for the default search engine.

# source of truth for URL aliases
# - used by url-alias-setup and url-alias
# - can be modified to add new aliases
declare -A __url_alias=(
	["g"]="https://google.com"
	["r"]="https://reddit.com"
	["h"]="https://news.ycombinator.com"
)

# url-alias
# - print the current URL aliases
function url-alias() {
	local green="\033[32m"
	local cyan="\033[36m"
	local reset="\033[0m"

	echo "${green}URL aliases:${reset}"
	for alias in "${!__url_alias[@]}"; do
		echo "${cyan}${alias}${reset} -> ${__url_alias[${alias}]}"
	done

	echo "${green}To add new aliases, edit the ${cyan}__url_alias${green} array and run ${cyan}url-alias-setup${reset}"
}

# return either 'linux' or 'macos'
function get_platform() {
	case "$(uname -s)" in
	Darwin)
		echo "macos"
		;;
	Linux)
		echo "linux"
		;;
	*)
		echo "unsupported platform"
		exit 1
		;;
	esac
}
platform=$(get_platform)

# url-alias-setup
# - sets up URL aliases
# - this is done by modifying the /etc/hosts file and the nginx configuration
# - if changes are made, nginx is (re)started
function url-alias-setup() {
	# nginx config (platform dependent)
	if [[ "$platform" == "macos" ]]; then
		local nginx_config="/usr/local/etc/nginx/nginx.conf"
	else
		local nginx_config="/etc/nginx/nginx.conf"
	fi

	# create new nginx config and hosts file
	local new_hosts=""
	read -r -d '' new_nginx_config <<'EOF'
events {}
http {
EOF

	for alias in "${!__url_alias[@]}"; do
		local url="${__url_alias[$alias]}"

		new_hosts="${new_hosts}\n127.0.0.1 ${alias}"

		read -r -d '' server_blocks <<EOF
    server {
        listen       80;
        server_name  ${alias};
        location / {
          rewrite ^ ${url} permanent;
        }
    }

EOF
		new_nginx_config="${new_nginx_config}\n    ${server_blocks}"
	done
	new_nginx_config="${new_nginx_config}\n}"

	# replace files
	# if file already exists, prompt user to overwrite
	echo "Saving new nginx config and hosts file..."
	if [[ -f "${nginx_config}" ]]; then
		echo "File ${nginx_config} already exists. Overwrite? (y/n)"
		read -r overwrite
		if [[ "${overwrite}" != "y" ]]; then
			echo "Aborting..."
			return 1
		fi
	fi
	echo -e "${new_nginx_config}" | sudo tee "${nginx_config}" >/dev/null
	if [[ -f "/etc/hosts" ]]; then
		echo "File /etc/hosts already exists. Overwrite? (y/n)"
		read -r overwrite
		if [[ "${overwrite}" != "y" ]]; then
			echo "Aborting..."
			return 1
		fi
	fi
	echo -e "${new_hosts}" | sudo tee /etc/hosts >/dev/null

	# start or restart nginx
	echo "Restarting nginx..."
	if [[ "$platform" == "macos" ]]; then
		nginx -s reload
	else
		sudo systemctl restart nginx
	fi
}

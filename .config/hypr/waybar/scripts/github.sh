#!/bin/bash

token=$(cat ${HOME}/.config/github/notifications.token)
count=$(curl -u iqbal1975:${token} https://api.github.com/notifications | jq '. | length')

if [[ "$count" != "0" ]]; then
	echo '{"text":'$count',"tooltip":"Notifications '$count'","class":"$class"}'
fi

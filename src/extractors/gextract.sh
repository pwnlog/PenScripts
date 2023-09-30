#!/usr/bin/bash

# Description: Extract host and ports from an Nmap GNMAP file.

while IFS= read -r line; do
	ip_address=$(echo "$line" | grep -oE 'Host: ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*Status: Up' | sed -E 's/Host: ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*Status: Up/\1/')
	if [ -z $ip_address ]; then
		:
	else
		echo "Host: $ip_address"
	fi
	port=$(echo $line | grep -oP '\d{1,5}/open' | sed -z 's/\/open//g; s/\n/,/g; s/,$/\n/')
	if [ -z $port ]; then
		:
	else
		echo "Port/s: $port"
		echo
	fi	
done < $1
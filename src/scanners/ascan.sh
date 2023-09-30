#!/bin/bash

# Description: A script that can be used to find assets.

usage() {
    echo "Usage: $0 <target_IP>"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

target_ip="$1"

sudo nmap -p- -sS -O -sV -oX scan_results.xml "$target_ip" -vvv --max-retries 10

hostname=$(grep -oP '<hostname name=".*?"' scan_results.xml | awk -F '"' '{print $2}' | uniq)
mac_address=$(grep -oP '<address addr=".*?" addrtype="mac"' scan_results.xml | awk -F '"' '{print $2}')
open_ports=$(grep -oP '<port protocol=".*?" portid=".*?">' scan_results.xml | awk -F '"' '{print $4}' | tr '\n' ',' | sed 's/,$//')
os_info=$(grep -oP '<osmatch name=".*?"' scan_results.xml | awk -F '"' '{print $2}')
service_info=$(grep -oP '<service name=".*?"' scan_results.xml | awk -F '"' '{print $2}' | tr '\n' ',' | sed 's/,$//')

if [ -z "$mac_address" ]; then
    mac_address="?"
fi

echo "Hostname: $hostname"
echo "MAC Address: $mac_address"
echo "Open Ports: $open_ports"
echo "Operating System: $os_info"
echo "Services: $service_info"
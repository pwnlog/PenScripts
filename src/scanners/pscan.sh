#!/bin/bash

# Description: A script that can be used when a port scanner is not available.

# Function to perform cleanup before exiting
cleanup() {
    echo -e "\n[!] Exiting..."
    # Add any cleanup commands here
    exit 1
}

# Set up trap to catch Ctrl+C (SIGINT)
trap cleanup SIGINT

# Function to validate an IP address
validate_ip() {
    local ip="$1"
    local pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

    if [[ "$ip" =~ $pattern ]]; then
        IFS='.' read -ra octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if [[ "$octet" -lt 0 || "$octet" -gt 255 ]]; then
                echo "[-] Invalid IP address: $ip"
                return 1
            fi
        done
    else
        echo "[-] Invalid IP address: $ip"
        return 1
    fi
}

# Function to validate a single port
validate_single_port() {
    local port="$1"

    if [[ "$port" -lt 1 || "$port" -gt 65535 ]]; then
        echo "[-] Invalid port: $port"
        return 1
    fi
}

# Function to validate a port range
validate_port_range() {
    local port_range="$1"
    local pattern="^[0-9]+-[0-9]+$"

    if [[ "$port_range" =~ $pattern ]]; then
        IFS='-' read -ra ports <<< "$port_range"
        if [[ "${ports[0]}" -gt "${ports[1]}" ]]; then
            echo "[-] Invalid port range: $port_range (start port is greater than end port)"
            return 1
        fi
    else
        echo "[-] Invalid port range: $port_range"
        return 1
    fi
}

# Function to perform a port scan
perform_port_scan() {
    local ip="$1"
    shift
    local ports=("$@")

    echo "[!] Scanning ports on $ip..."

    for port in "${ports[@]}"; do
        (echo > /dev/tcp/"$ip"/"$port") >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "[+] Port $port is open"
        fi
    done
}

# Get the IP address and port list from command line arguments
ip_address="$1"
shift
port_args=("$@")

# Validate the IP address and ports
if validate_ip "$ip_address"; then
    valid_ports=()
    for port_arg in "${port_args[@]}"; do
        if [[ "$port_arg" =~ ^[0-9]+$ ]]; then
            if validate_single_port "$port_arg"; then
                valid_ports+=("$port_arg")
            fi
        elif validate_port_range "$port_arg"; then
            IFS='-' read -ra ports <<< "$port_arg"
            for ((port = "${ports[0]}"; port <= "${ports[1]}"; port++)); do
                valid_ports+=("$port")
            done
        fi
    done

    perform_port_scan "$ip_address" "${valid_ports[@]}"
fi

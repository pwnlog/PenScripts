import re
import requests
import socket
import subprocess
import platform

# Description: Linux/Unix script for finding asset information

def get_ttl(ip_address):
    try:
        ping_output = subprocess.check_output(["ping", "-c", "1", ip_address], universal_newlines=True)
        ttl_match = re.search(r"ttl=(\d+)", ping_output, re.IGNORECASE)
        if ttl_match:
            if int(ttl_match.group(1)) == 64:
                return "Likely Unix/Linux based"
            elif int(ttl_match.group(1)) == 128:
                return "Likely Windows based"
            else:
                return "Unknown OS"
        else:
            return None
    except subprocess.CalledProcessError:
        return None

def get_mac_address(ip_address):
    pid = subprocess.Popen(["arp", "-n", ip_address], stdout=subprocess.PIPE)
    arp_output = pid.communicate()[0].decode("utf-8")
    mac_match = re.search(r"(([a-f\d]{1,2}:){5}[a-f\d]{1,2})", arp_output)
    if mac_match:
        return mac_match.group(0)
    return None

def get_vendor_info(mac_address):
    api_url = f"https://api.maclookup.app/v2/macs/{mac_address}"    
    try:
        response = requests.get(api_url)
        data = response.json()
        if "company" in data:
            vendor = data["company"]
            return vendor
        else:
            return "Vendor information not found"
    except requests.RequestException:
        return "MAC address lookup API app seems down"

if __name__ == "__main__":
    # Input
    ip_address = "192.168.21.130"

    # Output
    print(f"IP Address: {ip_address}")
    remote_os = get_ttl(ip_address)
    print(f"OS: {remote_os}")
    mac_address = get_mac_address(ip_address)
    print(f"MAC Address: {mac_address}")
    vendor = get_vendor_info(mac_address)
    print(f"Vendor: {vendor}")

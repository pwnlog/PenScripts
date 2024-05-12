import requests

# Description: Get MAC vendors

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
    with open('macs.txt') as mac_address:
    count = 0
    while True:
        line = mac_address.readline()
        if not line:
            break
        get_vendor_info(line.strip())
        count += 1
        print(f"Line{count}: {line.strip()}")
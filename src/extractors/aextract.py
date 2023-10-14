#!/usr/bin/python3

# Description: Extract asset information from an Nmap XML file and convert into CSV output.

import xml.etree.ElementTree as ET
import csv
import argparse

def parse_arguments():
    parser = argparse.ArgumentParser(description='Extract information from Nmap XML file and convert to CSV.')
    parser.add_argument('-i', '--input', help='Path to the Nmap XML file')
    parser.add_argument('-o', '--output', help='Path to the CSV output file')
    return parser.parse_args()

def main():
    args = parse_arguments()
    xml_file_path = args.input

    # Parsing the XML file
    tree = ET.parse(xml_file_path)
    root = tree.getroot()

    if not args.output.endswith(".csv"):
        args.output += ".csv"

    # Open a CSV file to write the extracted data
    csv_file = open(args.output, 'w', newline='')
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(['IP Address', 'Port', 'Service', 'MAC Address', 'Vendor', 'Device Type'])

    # Extracting information from the XML file and writing to the CSV
    for host in root.iter('host'):
        ip_address = host.find('address').attrib['addr']
        mac_address = ''
        vendor = ''
        device_type = ''
        for address in host.iter('address'):
            if 'mac' in address.attrib['addrtype']:
                mac_address = address.attrib['addr']
                vendor = address.attrib.get('vendor', '')
        ports = []
        services = []
        for port in host.iter('port'):
            ports.append(port.attrib['portid'])
            services.append(port.find('service').attrib.get('name', ''))
        for os in host.iter('osclass'):
            device_type = os.attrib.get('type', '')
        csv_writer.writerow([ip_address, ','.join(ports), ','.join(services), mac_address, vendor, device_type])

    # Close the CSV file
    csv_file.close()

    print(f"Extraction complete. Please check the {args.output} file for the results.")

if __name__ == "__main__":
    main()
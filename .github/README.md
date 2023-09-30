# Pencri

Collection of useful Linux scripts for organizing your pentesting workflow.

# Scripts

- `workspace.sh`: Create a workspace for the audit or pentest.
- `gextract.sh`: Extract hosts and ports from an Nmap GNMAP file. Useful when the file has multiple hosts.
- `pscan.sh`: Perform a port scan when port scanners aren't available on the system.
- `ascan.sh`: Perform a light asset scan.

# Usage

```sh
./workspace.sh company_name
```

```sh
./gextract.sh file.gnmap
```

```sh
./pscan.sh 192.168.0.5 22 9-999
```

```sh
./ascan.sh 192.168.0.2
```

# To Do

Add more scripts.
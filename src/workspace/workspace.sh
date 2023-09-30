#!/bin/bash

# Description: Create a workspace for pentesting.

# Get the current date in the desired format (YYYY-MM-DD)
current_date=$(date +"%Y-%m-%d")
company_name=$1

# Create the main directory structure
main_dir="Audit/$company_name_$current_date"
mkdir -p "$main_dir"

# Create subdirectories inside the main directory
subdirs=("discovery" "recon/external" "recon/internal" "initial_access" "loot/passwords" "loot/hashes" "exploitation" "post-exploitation" "post-exploitation/privilege_escalation" "post-exploitation/persistence" "post-exploitation/lateral_movement" "collection" "reports")
for subdir in "${subdirs[@]}"; do
    mkdir -p "$main_dir/$subdir"
done

echo "Folder structure created at: $main_dir"
#echo
#echo "Discovery: Add notes of the discovered services, platforms, and data"
#echo "Recon: Add notes of the discovered external network and internal network data"
#echo "Initial Access: Add notes on ways to gain initial access"
#echo "Exploitation: Add notes on ways to perform execution"
#echo "Post-Exploitation: Add notes about privilege escalation, persistence, and lateral movement"
#echo "Loot: Add notes about the passwords or hashes found"
#echo "Reports: Add notes for the reports"
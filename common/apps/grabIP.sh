#! /bin/bash

# Backup Directory
bkupDir="~/.dns_backup"
# Input list of websites to get IP address for
dnsFile="$bkupDir/dnsList.txt"
# Output filename for sites + IP addresses
date=`date +%m_%d_%y`
ipAddrFile="$bkupDir/ipList_$date.txt"

# Read through dns file, and grab URL
while IFS= read -r url
do
	# Debugging statement
	echo "Grabbing IP address for: $url"
	# Use ping to get IP Address from DNS (ping only once)
	output=`ping -c 1 $url`
	# Extract IP address from ping output
	ipAddr=$(echo $output| cut -d' ' -f 3)
	# Write ipAddress to output file
	echo "$url : $ipAddr" >> $ipAddrFile
done < "$dnsFile"

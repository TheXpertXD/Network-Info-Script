#!/bin/bash

#START SCRIPT

ip="$(hostname -I | awk '{print $1}')"
mac="$(cat /sys/class/net/enp0s3/address)"
gate="$(ip r | awk '/via/ {print}' | cut -d ' ' -f 3)"
speed="$(ethtool enp0s3 | awk '/Speed:/ {print}' | cut -d ' ' -f 2)"
dup="$(ethtool enp0s3 | awk '/Duplex:/ {print}' | cut -d ' ' -f 2)"

echo "Dynamic IPv4 Address: '$ip'"
echo "MAC Address: '$mac'"
echo "Gateway Router: '$gate'"
sudo cat /etc/resolv.conf | while IFS= read -r line
do
	header="$(echo "$line" | cut -d ' ' -f 1)"
	if [[ "$header" == "search" ]]; then
		domain="$(echo "$line" | cut -d ' ' -f 2)"
		echo "DNS Domain: '$domain'"
	fi
	if [[ "$header" == "nameserver" ]]; then
		server="$(echo "$line" | cut -d ' ' -f	2)"
                echo "DNS Server: '$server'"
	fi
done
echo "NIC Speed: '$speed'"
echo "Duplex: '$dup'"

#END SCRIPT

#!/bin/bash



RED='\033[0;31m'

GREEN='\033[0;32m'

NC='\033[0m' # No Color





if [ $# -ne 1 ];

then

	echo "Usage: ./nmap_scan.sh ip_address" 

	exit 1

fi

ip_addr=$1

echo -e ${RED}"............................................"

echo "Scanning and Enumerating top 1000 ports....."

echo "............................................"

echo ""

echo -e ${NC}""

nmap -sC -sV -A $ip_addr -vvv

echo -e ${RED}"...................................."

echo "Scanning for all 65535 ports........"

echo "...................................."

echo -e ${NC}""

echo ""

nmap_output=$(nmap -p- $ip_addr --min-rate=5000)

open_ports=$(echo "$nmap_output" | grep "open")

echo $open_ports

echo -e ${RED}"...................................."

echo "Enumerating all 65535 ports........."

echo "...................................."

echo -e ${NC}""

open_ports=$(echo "$nmap_output" | grep "open" | awk '{print $1}' | awk -F"/" '{print $1}')





port_array=()



# Read each word into the array

while IFS= read -r line; do

    port_array+=("$line")

done <<< "$open_ports"



for port in "${port_array[@]}"; do

    echo -e ${GREEN}"...................................."

    echo "Enumerating port"

    echo $port

    echo "...................................."

    echo -e ${NC}""

    nmap -sC -sV -A -p $port $ip_addr

done



echo -e ${RED}"..................................................."

echo "Scanning top 1000 udp ports........"

echo "..................................................."

echo ""

echo -e ${NC}""

nmap -sU --top-ports 1000 $ip_addr


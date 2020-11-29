#!/bin/sh

: ${1:?usage: ${0##*/} <host file>, where host file contains one host fqdn or ip address per line. outputs a csv file containing hostname, certificate expiry date, and days to expire.}
file="$1"

os=$(uname -s)

[ ! -s "$file" ] && {
	echo "error: $file does not exist or is empty"
	exit 2
}

echo "host,expiry,validity"

while read -r line; do
	hold=$(echo | openssl s_client -connect $line:443 2>/dev/null | openssl x509 -text 2>/dev/null) 
	if [ $? -ne 0 ]; then
		echo "$line,N/A,N/A" >> $out
	else
		exp=$(echo "$hold" | sed -n 's/Not After : //p' | sed -e 's/^[ \t]*//')
		today=$(date +"%s")
		if [ "$os" == "Linux" ]; then
			expstd=$(date -d "$exp" "+%s")
		elif [ "$os" == "Darwin" ]; then
			expstd=$(date -j -f "%b %d %H:%M:%S %Y %Z" "$exp" +"%s")
		else
			echo "error: unknown os [$os]. need either linux or macos"
			exit 2
		fi
		diff="$(( ($expstd-$today) / (24*3600) ))"
		echo "$line,$exp,$diff"
	fi
done < $file

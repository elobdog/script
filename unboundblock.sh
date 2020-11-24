#!/bin/sh

URL="https://dbl.oisd.nl"
TMPFILE=$(mktemp) || exit 1
BLOCKL="blockhost.conf"
UBOUND="/var/unbound"
DATE=$(date '+%Y%m%d')

echo "====[script start: $(date)]===="

[ -f $BLOCKL ] && \
	mv $BLOCKL $BLOCKL.$DATE

if [ "$(uname -s)" == "OpenBSD" ]; then
	#ftp -S noverifytime -o $TMPFILE $URL
	ftp -o $TMPFILE $URL
else
	wget -c --passive -O $TMPFILE $URL
fi

sed -e '/^#/d' -e '/^$/d' \
	-e 's/\(.*\)/local-zone: "\1" always_nxdomain/' \
	$TMPFILE > $TMPFILE.TMP \
	&& mv $TMPFILE.TMP $BLOCKL \
	&& rm -f $TMPFILE

# Move the file to unbound's directory
#mv $BLOCKL $UBOUND/etc/ && \
#	unbound-control reload && \
	rm -f $BLOCKL.$DATE

echo "====[script end: $(date)]===="

#!/bin/sh

URL="https://dbl.oisd.nl"
TMPFILE=$(mktemp) || exit 1
BLOCKL="blockhost.conf"
UBOUND="/var/unbound"
DATE=$(date '+%Y%m%d')
OS=$(uname -s)

trap 'rm -f $TMPFILE' INT HUP TERM

echo "====[script start: $(date)]===="

[ -f $BLOCKL ] && \
	mv $BLOCKL $BLOCKL.$DATE

if [ "$OS" == "OpenBSD" ]; then
	# use "-S noverifytime" in case of certain errors. man 1 ftp
	ftp -o $TMPFILE $URL
else
	wget -c --passive -O $TMPFILE $URL
fi

sed -e '/^#/d' -e '/^$/d' \
	-e 's/\(.*\)/local-zone: "\1" always_nxdomain/' \
	$TMPFILE > $TMPFILE.TMP \
	&& mv $TMPFILE.TMP $BLOCKL \
	&& rm -f $TMPFILE

# move the file to unbound's etc directory
if [ "$OS" == "OpenBSD" ]; then
	mv $BLOCKL $UBOUND/etc/
fi

# cleanup, since the new blocklist generated successfully
rm -f $BLOCKL.$DATE

echo "====[script end: $(date)]===="

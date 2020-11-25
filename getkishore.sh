#!/bin/sh

base="http://kishor.ebalbharati.in/Archive/include/pdf"

start=1973
year=$(date +%Y)

#for i in {1973..$year}; do
for i in $(seq $start $year); do
	for j in $(seq 1 9); do
		wget -c --passive $base/${i}_0${j}.pdf
	done

	for k in $(seq 10 12); do
		wget -c --passive $base/${i}_${k}.pdf
	done
done

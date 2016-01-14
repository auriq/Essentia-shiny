#!/bin/bash

year=1929

while [ $year -lt 2010 ]; do
 basename -a `ess ls /climate/gsod/$year -r`|cut -c1-12  >> stationlist.csv
 let "year +=1"
done

cat stationlist.csv | sort -u > uniqueid.csv
rm stationlist.csv

#!/usr/bin/env bash

# Name: kskbkup.sh
# Author: Nicholas Neal (nwneal@kisoki.com)
# About: script for backing up a site

##############################
### Settings
##############################

# Directory to be backed up
bkupdir="/dir/of/site"

# Location to backup of site
bkupto="/tmp"

# Name of backup file
bkupname="site_archive_"

# add timestamp
addtmstmp=true
tmstmp=""

##############################
### Functions
############################## 



##############################
### Check Settings
##############################

if [ ! -e "$bkupdir" ]; then
	echo "$0: FATAL - Directory to be backed-up does not exist."
	exit 0
fi

if [ ! -e "$bkupto" ]; then
	echo "$0: FATAL - Directory for backup does not exist."
	exit 0
fi

if [ $addtmstmp ]; then
	tmstmp=$(date +%Y%m%d%H%M)
fi

##############################
### Main
##############################
cd $bkupto
tar -czf "$bkupname$tmstmp.tar.gz" "$bkupdir"
chmod 440 "$bkupname$tmstmp.tar.gz" # Set backup file to read only to owner and group only.

# EOF


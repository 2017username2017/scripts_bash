#!/bin/bash

# =================================================================
#			      My system
# =================================================================

clear
echo " ================================================================="
echo "This is information provided by mysystem.sh Program starts now."
echo " ================================================================="

echo "Hello, $USER"
echo 

#echo "Today's date is 'date' this is week 'date +"%V"'."
echo "Today's date is: $(date) "
echo

#echo "These users are currently connected.\n"
#w | cut -d " " -f 1 - | grep -v USER | sort -u
echo "These users are currently connected:"
w | cut -d "" -f 1 | grep -v USER | sort -u
#echo "This is 'uname -s' running on a 'uname -m' processor."
echo
echo "This is $(uname -s) running on $(uname -m)"
echo

echo "This is the uptime information: "
uptime


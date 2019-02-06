#!/bin/bash

# =================================================
#	   Check for existence of a file
# =================================================

echo '================================================='
echo 'This script checks the existence of a messages file.'
echo '================================================='
echo
echo 'Checking...'
echo
if [ -f /var/log/messages ]
	then 
		echo '/var/log/messages exists.'
fi
echo
echo 'End of program.'



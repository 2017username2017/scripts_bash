#!/bin/bash

# =============================================================
#		    File Information Program
# =============================================================
echo '========================================================'
echo '		     File Information Program		      '
echo '========================================================'
echo
FILENAME ='$1'
echo "Properties for $(FILENAME)"

if [ -f $(FILENAME) ]; then
	echo "Size is $(ls -lh $(FILENAME) | awk '{  print $(5 }')"
	echo "Type is $(file FILENAME) | cut -d':' -f2 -)"
	echo "Inode number is $(ls -i $(FILENAME) | cut 



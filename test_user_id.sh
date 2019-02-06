#!/bin/bash

# =============================================
#		Test user ID
# =============================================

echo '============================================'
echo ' 		    Test User ID	          '
echo '============================================'
echo
if [ "$(whoami)" != 'root' ]; then
	echo 'You have no permission to run $0 as non-root user.'
	exit 1;
fi
# ==================================================
# code below created syntax error near unexpected token 'fi'
# =================================================
#echo
#if [ "$(whoami)" != 'root' ] && ( echo 'You are using a non-privileged account'; exit 1 ) 
#fi

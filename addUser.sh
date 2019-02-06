#!/bin/bash
. checkUserExists.sh


check_user_exists
echo ' ============================================================= '
echo '                         Main Menu            '
echo ' ============================================================= '

# Check if user exists

# Menu selection
echo '1. Add user'
echo '2. Delete user'
echo '3. Disable user account'
echo '4. Enable user account'
echo '5. Add user to group'
echo '6. Create a group'
echo 
# Make selection
echo 'Select menu item:' 
read item
case $item in  
	1)	
		echo 'Enter user name to add user'
		read name
		useradd -m $name
		echo 'User name has been added.' 
		;;
	2)
		echo 'Enter user name to delete'
		read user
		#if [ $user -eq 1 ];
		if [[ '$user' == '$user' ]];
		then
			echo $user 'exists.'
			echo 
			read -p 'Delete user? y/n ' delete
			if [[ $delete = y ]] ; then
			userdel -r $user
			echo 'User' $user 'has been removed from the system.'
		else
			echo $user ' has not been deleted.'
		fi
		else
			echo 'Return to main menu.'
		fi
		;;	
	3)	
		echo 'Enter user name to disable'
	        read disableUser
		echo 'Are you sure you would like to disable ' $disableUser '?'
		read response
		if [[ $response = y ]] ; then
		usermod -L $disableUser
		echo 'User ' $disableUser "'s has been disabled."
	        fi
		;;
	4)	
		echo
		echo 'Enter user name to unlock'
		read unlockUser
		echo 'Are you sure that you would like to unlock ' $unlockUser '?'
		read response2
		if [[ $response2 = y ]] ; then
		usermod -U $unlockUser
		usermod -p  
		echo 'User ' $unlockUser "'s account has been unlocked."
		fi	
		;;

	5) 	echo 'Enter name of group to add a user to: '
		read group
		echo 'Enter name of existing user account to add to '.$group
		read userAccount
		usermod -a -G $group $userAccount
		echo
		echo 'Success!'
		echo $userAccount ' has been added to the group' $group
		echo
		echo 'List of user accounts which belong to ' $group
		echo '--------------------------------------------'
		getent group | grep $group
		echo
		;;
	6) 	echo	
		echo 'Enter name of group to create: '
		read groupName
		if [ $(getent group $groupName) ]; then
			echo 'Group ' $groupName ' already exists.'
		else
		groupadd $groupName
		echo	
		echo 'Success!'
		echo $groupName ' has been created.'
		echo
		getent group | grep $groupName
	fi
		echo
		;;	
		*)
		echo 'End of program.';;

	
esac

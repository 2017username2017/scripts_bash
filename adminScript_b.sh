#!/bin/bash

# Define variables
LSB=/usr/bin/lsb_release

# Purpose: Display pause prompt
# $1-> Message (optional)

function pause() {
	local message="$@"
	[[ -z $message ]] && message="Press [Enter] key to continue..."
	read -p "$message" readEnterKey

}

# Purpose - Display menu on screen
function show_menu() {
	echo ""
	date
	echo "-------------------------------"
	echo "          Main Menu "
	echo "-------------------------------"
	echo "1. Operating system information"
	echo "2. Hostname and DNS information"
	echo "3. Network information"
	echo "4. Who is online"
	echo "5. Last logged in users"
	echo "6. Free and used memory information"
	echo "7. Get my IP address"
	echo "8. My disk usage"
	echo "9. Process usage"
	echo "10. Users operations"
	echo "11. File operations"
	echo "12. Exit"

}

show_menu;

# Purpose - display header message
# $1 - message
function write_header() {
	local h="$@"
	echo ""
	echo "--------------------------------------------"
	echo "${h}"
	echo "--------------------------------------------"
	echo ""
}

write_header;

# Purpose - get information about your operating system
function os_info() {
	write_header "           Operating system information "
	echo "Operating system: $(uname)"
	echo ""
	[[ -x $LSB ]] && $LSB -a || echo "$LSB command is not installed (set \$LSB variable)"
	# pause - "Press [Enter] to continue..."
	pause 

}

os_info;

# Purpose - get information about host such as DNS, IP, and hostname
function host_info() {
	local dnsips=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}')
	write_header "          Hostname and DNS information "
	echo "Hostname : $(hostname -s)"
	echo "DNS domain : $(hostname -d)"
	echo "Fully qualified domain name : $(hostname -f)"
	echo "Network address(IP) : $(hostname -i)"
	echo "DNS name servers (DNS IP) : ${dnsips}"
	pause

}

host_info;


# Purpose - network interface and routing information
function net_info() {
	devices=$(netstat -i | cut -d" " -f1 | egrep -v "^Kernel|Iface|lo")
	write_header "      Network information "
	echo "Total network interfaces found : $(wc -w <<<${devices})"

	echo "*** IP Address Information ***"
	ip -4 address show

	echo "********************************************"
	echo "*********** Network routing ****************"
	echo "********************************************"
	netstat -nr

	echo ""
	echo ""
	echo "********************************************"
	echo "******* Interface traffic information ******"
	echo "********************************************"
	netstat -i


	pause

	}


net_info;

# Purpose - display a list of users currently logged on
# Display a list of recently logged in users
function user_info() {
	local cmd="$1"
	case "$cmd" in
		who) write_header "    Who is online" ; w; pause;;
		#who) write_header "    Who is online" |  who -H |  pause ;;
		last) write_header "   List of last logged in users " | last | pause;;
	esac

}

user_info;


# Purpose - display used and free memory information
function mem_info() {
	write_header "     Free and used memory    "
	free -m

	echo "********************************************"
	echo "***   Virtual Memory Statistics         ****"
	echo "********************************************"
	vmstat
	echo "********************************************"
	echo "***   Top 5 memory eating processes     ****"
	echo "********************************************"
	ps auxf | sort -nr -k 4 | head -5
	pause 


}

mem_info;


# Purpose - get public IP address from your ISP
function ip_info() {
	# cmd="curl -s"
	write_header "      Public IP Information   "
	# commented line below to get public IP
	# ipservice=http://www.checkip.dyndns.org
	#hostname -I
	echo "Current IP Address : $(hostname -I)"
	echo ""
	echo ""
	echo ""
	# pipecmd=(sed -e 's/.*Current IP Address: //' -e 's/<.*$//') 
	# using brackets to use it as an array and avoid need of scaping
	# $cmd="$ipservice" | "${pipecmd[@]}"
	pause

}

ip_info;

# Purpose - get disk usage information

function disk_info() {
	#usep=$(echo $output | awk '{ print $1 }' | cut -d'%' -f1)
		#partition=$(echo $output | awk '{print $2}')
	write_header ' Disk usage information '
	#if [[ '$EXCLUDE LIST' != '' ]] ; then
		df -H | grep -vE tmpfs | grep -vE cdrom 
		#| grep -vE "^Filesystem | tmpfs | cdrom | ${EXCLUDE_LIST}" | awk '{print $5 "" $6}'
	#fi
	pause
}

disk_info;


# Purpose - process usage information

function proc_info() {
 	write_header "       Process Usage Information  "
	txtred=$(tput setaf 1)
	txtgrn=$(tput setaf 2)
	txtylw=$(tput setaf 3)
	txtblu=$(tput setaf 4) 
	txtpur=$(tput setaf 5) 
	txtcyn=$(tput setaf 6) 
	txtrst=$(tput sgr0) 
	COLUMNS=$(tput cols)

	center() {
		w=$(( $COLUMNS / 2 - 20 ))
		while IFS= read -r line
		do
			printf "%${w}s %s\n" '' "$line"
		done
	}
	
	centerwide() {
		w=$(( $COLUMNS / 2 - 30 )) 
		while IFS= read -r line
		do
			printf "%${w}s %s\n" '' "$line"
		done
	}

	while :
	do
		clear
		
		echo ""
		echo ""
		echo "${txtcyn}(please enter the number of your selection)${txtrst}" | centerwide
		echo ""
		echo "1. Show all processes" | center
		echo "2. Kill a process" | center
		echo "3. Bring up top" | center
		echo "4. ${txtpur}Return to Main Menu${txtrst}" | center
		echo "5. ${txtred}Shut down${txtrst}" | center
		echo ""

		read processmenuchoice
		case $processmenuchoice in
			1 ) 
				clear && echo "" && echo "${txtcyn}(press ENTER  or use arrow keys to scroll list, press Q to return to menu)${txtrst}" | centerwide && read
				ps -ef | less
				;;

			2 ) 
				clear && echo "" && echo "Please enter the PID of the process you would like to kill: " | centerwide
				read pidtokill
				kill -2 $pidtokill && echo "${txtgrn}Process terminated successfully.${txtrst}" | center || echo "${txtred}Process failed to terminate. Please check the PID and try again.${txtrst}" | centerwide
				echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center && read
				;;

			3 )
				top
				;;

			4 )
				clear && echo "" && echo "Are you sure you want to return to the main menu?${txtcyn}y/n${txtrst}" | centerwide && echo ""
				read exitays
				case $exitays in
					y | Y )
						clear && exit
						;;
					n | N )
						clear && echo "" && echo "Okay. Nevermind then. " | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
						;;

					* ) 
						clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" || center && read
				esac
				;;

			5 ) 
				clear && echo "" && echo "Are you shure you want to shut down?${txtcyn}y/n${txtrst}" | centerwide && echo ""
				read shutdownays
				case $shutdownays in
					y | Y )
						clear && shutdown -h now
						;;
					n | N ) 
						clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.${txtrst}" | center && read
						;;
					* ) 
						clear && echo "" && echo "${txtred}Please make a valid selection." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
						;;
				esac
				;;

			* )
				clear && echo "" && echo "${txtred}Please make a valid selection. " | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
				;;
		esac

	
	done
	pause
}

proc_info;

# ===============================================================
#	   Purpose - User operations and information
# ===============================================================
function user_infos() {
	write_header "User Operations"

	txtred=$(tput setaf 1)
	txtgrn=$(tput setaf 2)
	txtylw=$(tput setaf 3)
	txtblu=$(tput setaf 4)
	txtpur=$(tput setaf 5)
	txtcyn=$(tput setaf 6)
	txtrst=$(tput sgr0)
	COLUMNS=$(tput cols)

	center() {
		w=$(( $COLUMNS / 2 - 20 )) 
		while IFS= read -r line
		do
			printf "%${w}s %s\n" ' ' "$line"
		done
	}

	centerwide() {
		w=$(( $COLUMNS / 2 - 30 ))
		while IFS= read -r line
		do
			printf "%${w}s %s\n" ' ' "$line"
		done
	}




	while :
	do

		clear

		echo ""
		echo ""
		echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
		echo ""
		echo "1. Create a user" | center
		echo "2. Change the group for a user" | center
		echo "3. Create a group" | center
		echo "4. Delete a user" | center
		echo "5. Change a password" | center
		echo "6. ${txtpur}Return to Main Menu${txtrst}" | center
		echo "7. ${txtred}Shut down${txtrst}" | center
		echo ""

		read usermenuchoice
		case $usermenuchoice in
			1 )
				clear && echo "" && echo "Please enter the new username below: ${txtcyn}(NO SPACES OR SPECIAL CHARACTERS!)${txtrst}" | centerwide && echo ""
				read newusername
				echo "" && echo "Please enter a group for the new user: ${txtcyn}(STILL NO SPACES OR SPECIAL CHARACTERS!)${txtrst}" | centerwide && echo ""
				read newusergroup
				echo "" && echo "What is the new user's full name? ${txtcyn}(YOU CAN USE SPACES HERE IF YOU WANT!)${txtrst}" | centerwide && echo ""
				read newuserfullname
				echo "" && echo ""
				groupadd $newusergroup
				useradd -g $newusergroup -c "$newuserfullname" $newusername && echo "${txtgrn}New user $newusername created successfully.${txtrst}" | center || echo "${txtred}Could not create new user.${txtrst}" | center
				echo "" && echo "${txtcyn}(press Enter to continue)${txtrst}" | center
			read
			;;

		      2 )
			      clear && echo "" && echo "Which user needs to be in a different group? ${txtcyn}(USER MUST EXIST!)${txtrst}" | centerwide && echo ""
	      		      read usermoduser
			      echo "" && echo "What should be the new group for this user? ${txtcyn}(NO SPACES OR SPECIAL CHARACTERS!)${txtrst}" | centerwide && echo ""
			      read usermodgroup
			      echo "" && echo ""
			      groupadd $usermodgroup
			      usermod -g $usermodgroup $usermoduser && echo "${txtgrn}User $usermoduser added to group $usermodgroup successfully.${txtrst}" | center || echo "${txtred}Could not add user to group. Please check if user exists.${txtrst}" | centerwide
			      echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center
			      read
			      ;;

	              3 )
			      clear && echo "" && echo "Please enter a name for the new group below: ${txtcyn}(NO SPACES OR SPECIAL CHARACTERS!)${txtrst}" | centerwide && echo ""
			      read newgroup
			      echo "" && echo ""
			      groupadd $newgroup && echo "${txtgrn}Group $newgroup created successfully.${txtrst}" | center || echo "${txtred}Failed to create group. Please check if group already exists.${txtrst}" | centerwide
			      echo "" && echo "${txtcyn}(press ENTER to continue${txtrst}" | center
			      read
			      ;;
		      4 )
			      clear && echo "" && echo "Please enter the username to be deleted below: ${txtcyn}(THIS CANNOT BE UNDONE!)${txtrst}" | centerwide && echo ""
			      read deletethisuser
			      echo "" && echo "${txtred}ARE YOU ABSOLUTELY SURE YOU WANT TO DELETE THIS USER? SERIOUSLY, THIS CANNOT BE UNDONE!) ${txtcyn}y/n${txtrst}" | centerwide
			      read deleteuserays
			      echo "" && echo ""
			      case $deleteuserays in
				      y | Y )
					      userdel $deletethisuser && echo "${txtgrn}User $deletethisuser deleted successfully." | center || echo "${txtred}Failed to delete user. Please check username and try again.${txtrst}" | centerwide
					     ;;

			              n | N )
					      echo " Okay. Nevermind then." | center
					      ;;
				      * )
					      echo "${txtred}Please make a valid selection.${txtrst}" | center
					      ;;
			      esac
			      echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center
			      read
			      ;;
	              5 )
			      clear && echo "" && echo "Which user's password should be changed?" | centerwide
			      read passuser
			      echo ""
			      passwd $passuser && echo "${txtgrn}Password for $passuser changed successfully.${txtrst}" | center || echo "${txtred}Failed to change password.${txtrst}" | center
			      echo "" && echo "${txtcyn}(press ENTER to continue)${txtrst}" | center
			      read
			      ;;
		      6 )
			      clear && echo "" && echo "Are you sure you want to return to the main menu? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
			      read exitays
			      case $exitays in
				      y | Y )
					      clear && exit
					      ;;
				      n | N )
					      clear && echo "" && echo "Okay. Nevermind then. " | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
					      ;;
				      * )
					      clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.${txtrst}" | center && read
					      ;;
			      esac
			      ;;
	              7 )
			      clear && echo "" && echo "Are you sure you want to shut down? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
			      read shutdownays
			      case $shutdownays in
				      y | Y )
					      clear && shutdown -h now
					      ;;
				      n | N )
					      clear && echo "" && echo "Okay. Nevermind then." | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
					      ;;
				      * )
					      clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
					      ;;
			      esac
			      ;;
		      * )
			      clear && echo "" && echo "${txtred}Please make a valid selection.${txtrst}" | center && echo "" && echo "${txtcyn}(Press ENTER to continue.)${txtrst}" | center && read
			      ;;
	      esac
      done
     pause
}

user_infos;


# ===============================================================
#	            Purpose - For File Operations 
# ===============================================================
function file_info() {
write_header "File Operations"
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)
COLUMNS=$(tput cols)

center() {
	w=$(( $COLUMNS / 2 - 20 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" '' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" '' "$line"
	done
}

while :
do
	clear

	echo ""
	echo ""
	echo "${txtcyn}(please enter the number of your selection below)${txtrst}" | centerwide
	echo ""
	echo "1. Create a file" | center
	echo "2. Delete a file" | center
	echo "3. Create a directory" | center
	echo "4. Delete a directory" | center
	echo "5. Create a symbolic link" | center
	echo "6. Change ownership of a file" | center
	echo "7. Change permission ona  file" | center
	echo "8. Modify text within a file" | center
	echo "9. Compress a file" | center
	echo "10. Decompress a file" | center
	echo "11. ${txtpur}Return to main menu${txtrst}" | center
	echo "12. ${txtred}Shut down${txtrst}" | center
	echo ""

	read mainmenuchoice
	case $mainmenuchoice in
		1 )

}

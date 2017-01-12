#!/usr/bin/env bash

##############################################################################
# Name: createid.sh                         ##################################
# Version: 1.1.0                            ##################################
# Author: Nicholas Neal (nwneal@kisoki.com) ##################################
##############################################################################
# Description: used to create IDs on multiple servers. for more info, please #
#              refer to the documentation for this script.                   #
#			   (createID.sh.documentation)                       #
##############################################################################

sparam=false # used to see if server file has been set.
iparam=false # used to see if info file has been set.

SOURCEFILE="" # variable that carries file with server names.
INFOFILE="" # variable that carries file with new ID info.

REDT='\033[0;31m' # add red to text
GRNT='\033[0;32m' # add green to text
YELT='\033[1;33m' # add yellow to text
BLUT='\033[0;34m' # add blue to text
PRPT='\033[1;35m' # add light puple to text
NOCT='\033[0m' # add no color to text

printf "${YELT}Running Parameter check and variable assignment...${NOCT}\n"

# check if there are 4 arguments in command line
if [ $# -lt 4 ]; then
	printf "${REDT}$0 Error: missing arguments.${NOCT}\n"
	exit 0
elif [ $# -gt 4 ]; then 
	printf "${REDT}$0 Error: too many arguments.${NOCT}\n"
	exit 0
fi 

# assign source file argument to proper variable.
if [ $1 == "-s" ]; then
	SOURCEFILE=$2
	sparam=true
elif [ $3 == "-s" ]; then
	SOURCEFILE=$4
	sparam=true
fi

# assign info file argument to proper variable.
if [ $1 == "-i" ]; then
	INFOFILE=$2
	iparam=true
elif [ $3 == "-i" ]; then 
	INFOFILE=$4
	iparam=true
fi

# check if paramaters have been set, otherwise exit with error code.
if [ $sparam == false ] || [ $iparam == false ]; then
	printf "${REDT}$0 Error: invalid paramaters.${NOCT}\n"
	exit 0
fi

# check if source file exists and is readable.
if [ ! -e $SOURCEFILE ]; then
	printf "${REDT}$0 Error: '$SOURCEFILE' does not exist.${NOCT}\n"
	exit 0
fi

if [ ! -r $SOURCEFILE ]; then
	printf "${REDT}$0 Error: '$SOURCEFILE' is not readable.${NOCT}\n"
	printf "${PRPT}Run 'chmod ug+r $SOURCEFILE' and try again.${NOCT}\n"
	exit 0
fi

# check if info file exists and is readable.
if [ ! -e $INFOFILE ]; then
	printf "${REDT}$0 Error: '$INFOFILE' does not exist.${NOCT}\n"
	exit 0
fi

if [ ! -r $INFOFILE ]; then
	printf "${REDT}$0 Error: '$INFOFILE' is not readable.${NOCT}\n"
	printf "${PRPT}Run 'chmod ug+r $INFOFILE' and try again.${NOCT}\n"
	exit 0
fi

#check info file and return to assigned variables.
printf "${YELT}checking '$INFOFILE' for new user info...${NOCT}\n"
istart=`cat $INFOFILE | cut -d ":" -f1`
ifinish=`cat $INFOFILE | cut -d ":" -f10`
if [ $istart == "STARTFILE" ] && [ $ifinish == "ENDFILE" ]; then
	stopScript=false # if variable set to true, the script will halt at the end of check.

	# assign username and check.
	printf "${GRNT}-- assigning username.${NOCT}\n"
	username=`cat $INFOFILE | cut -d ":" -f2`
	if [ -z "$username" ]; then
		printf "${REDT}  !- missing username.${NOCT}\n"
		stopScript=true
	fi

	# assign primary group and check.
	printf "${GRNT}-- assigning primary group.${NOCT}\n"
	pgroup=`cat $INFOFILE | cut -d ":" -f3`
	if [ -z "$pgroup" ]; then
		printf "${REDT}  !- missing primary group.${NOCT}\n"
		stopScript=true
	fi

	# assign secondary groups.
	printf "${GRNT}-- assigning secondary groups.${NOCT}\n"
	sgroup=`cat $INFOFILE | cut -d ":" -f4`


	# Assign ID type and check.
	printf "${GRNT}-- assigning ID type.${NOCT}\n"
	IDtype=`cat $INFOFILE | cut -d ":" -f7`
	if [ -z "$IDtype" ]; then
		printf "${REDT}  !- missing ID type.${NOCT}\n"
		stopScript=true
	fi
	
	# assign serial number and check.
	printf "${GRNT}-- assigning serial number.${NOCT}\n"
	serial=`cat $INFOFILE | cut -d ":" -f5`
#	if [ -z "$serial" ] && [ $IDtype != "E" ]; then
#		printf "${REDT}  !- missing serial number.${NOCT}\n"
#		stopScript=true
#	fi

	# assign name and check.
	printf "${GRNT}-- assigning name.${NOCT}\n"
	name=`cat $INFOFILE | cut -d ":" -f6` 
	if [ -z "$name" ]; then
		printf "${REDT}  !- missing name.${NOCT}\n"
		stopScript=true
	fi

	# Assign ID change info and check.
	printf "${GRNT}-- assigning ID change info.${NOCT}\n"
	info=`cat $INFOFILE | cut -d ":" -f8`
	if [ -z "$info" ]; then
		printf "${REDT}  !- missing ID change info.${NOCT}\n"
		stopScript=true
	fi

	# assign agency.
	printf "${GRNT}-- assigning agency.${NOCT}\n"
	agency=`cat $INFOFILE | cut -d ":" -f9`


	# stop script if needed parameters are missing.
	if [ $stopScript == true ]; then
		echo ""
		printf "${REDT}$0 Error: missing needed parameters from '$INFOFILE'.${NOCT}\n"
		printf "${PRPT}please see above for needed parameters.${NOCT}\n"
		exit 0
	fi
	
else
	printf "${REDT}$0 Error: '$INFOFILE' is incorrectly formatted.${NOCT}\n"
	printf "${PRPT}See Documentation for creating info file.${NOCT}\n"
	exit 0
fi

# print variables and question user if they are correct.
printf "${YELT}Check to see if variables are correct:${NOCT}\n\n"

printf "${YELT}  USERNAME:${NOCT} $username\n"
printf "${YELT}  PRIMARY GROUP:${NOCT} $pgroup\n"
printf "${YELT}  SECONDARY GROUP:${NOCT} $sgroup\n"
printf "${YELT}  ID TYPE:${NOCT} $IDtype\n"
printf "${YELT}  SERIAL:${NOCT} $serial\n"
printf "${YELT}  NAME:${NOCT} $name\n"
printf "${YELT}  CHANGE INFO:${NOCT} $info\n"
printf "${YELT}  AGENCY:${NOCT} $agency\n\n"

while true; do
	printf "  ${YELT}Are the variables correct? ('y' or 'n'): "
	read -p "" rdchk

	if [ -z $rdchk ]; then
		printf "${REDT}  Invalid input, try again.${NOCT}\n\n"
	elif [ $rdchk == "y" ] || [ $rdchk == "Y" ]; then
		echo ""
		break
	elif [ $rdchk == "n" ] || [ $rdchk == "N" ]; then
		printf "${PRPT}  Exiting script now.${NOCT}\n"
		printf "${PRPT}  Check paramaters, and run again.${NOCT}\n"
		exit 0
	else
		printf "${REDT}  Invalid input, try again.${NOCT}\n\n"
	fi	
done

printf "${PRPT}#${GRNT}#${BLUT}#${REDT}#${YELT} Parameter Check Finished ${REDT}#${BLUT}#${GRNT}#${PRPT}#${NOCT}\n"
printf "${GRNT}Press 'Enter' to continue...${NOCT}"
read -p ""

# set note for copying password for paste...
printf "\n${BLUT} **NOTE: ${PRPT}You will want to copy your password for each server and \npaste it, because this script will ask for your password A LOT!!!.\nIt is suggested that you set up SSH keys.${NOCT}\n\n"
printf "${GRNT}Press 'Enter' to continue...${NOCT}"
read -p ""

# start loop for reading servers
lncnt=$(cat $SOURCEFILE | wc -l)
lncrt=1
printf "${YELT}Starting server loop...${NOCT}\n\n"

dcm_srv="$username.decomm_servers.lst"
error_srv="$username.createID.unreachable_servers.lst"
touch ./$error_srv

while true; do
	read -r line <&3 || break
	servername=`echo ${line,,}|cut -d";" -f1`
	
	printf "${YELT}Server ${NOCT}$lncrt${YELT} out of ${NOCT}$lncnt\n"
	lncrt=$((lncrt+1))
	
	# instruct user to prep for password.
	printf "${PRPT}Prepare password for: ${NOCT}$servername\n"
	printf "${GRNT}Press 'Enter' to continue...${NOCT}"
	read -p ""
	echo ""

	#check if server is reachable. if not, add to list and skip
#	ssh -t -q $servername "ls" *>/dev/null
#	if [ "$?" == "255" ] || [ "$?" == "130" ]; then
#		printf "${REDT}!!ERROR!! ${YELT} Unable to reach '${NOCT}$servername${YELT}'.${NOCT}\n"
#		printf "${YELT}Adding server to '${NOCT}$error_srv${YELT}'.${NOCT}\n\n"
#		echo "$servername" >> ./$error_srv 
#		continue
#	fi
	

	#setup script for grabbing user info.
	InfoGrab="$servername.$username.infograb.sh"	
	touch ./$InfoGrab
	echo "#!/bin/bash" >> ./$InfoGrab
	echo "" >> ./$InfoGrab
	echo "# this script is for grabbing ID info on $servername" >> ./$InfoGrab
	echo "" >> ./$InfoGrab

	echo "idchk=\"\`grep -wi $username /etc/passwd\`\"" >> ./$InfoGrab
	echo "usrchk=0" >> ./$InfoGrab	
	echo "if [ ! -z \"\$idchk\" ]; then" >> ./$InfoGrab
	echo "	# grab comments section from /etc/passwd output" >> ./$InfoGrab
	echo "	geccossrch=\`echo \$idchk | cut -d \":\" -f5\`" >> ./$InfoGrab
	echo "	# grab id type, serial number and name." >> ./$InfoGrab
	echo "	idtypesrch=\`echo \$geccossrch | cut -d \"/\" -f2\`" >> ./$InfoGrab
	echo "	serialsrch=\`echo \$geccossrch | cut -d \"/\" -f3\`" >> ./$InfoGrab
	echo "	namesrch=\`echo \$geccossrch | cut -d \"/\" -f5\`" >> ./$InfoGrab
	echo "	fnamesrch=\`echo \"$name\" | cut -d \" \" -f1\`" >> ./$InfoGrab
	echo "	lnamesrch=\`echo \"$name\" | cut -d \" \" -f2\`" >> ./$InfoGrab
	echo "" >> ./$InfoGrab
	echo "	# if \$serialsrch is not empty, compare by serial number." >> ./$InfoGrab
	echo "	if [ ! -z \$serialsrch ] && [ ! -z \"$serial\" ]; then" >> ./$InfoGrab
	echo "		if [ ! -z \"\`echo \$serialsrch | grep -wi $serial\`\" ]; then" >> ./$InfoGrab
	echo "			# if serial number exists and matches, set up for modify." >> ./$InfoGrab
#				printf 	"${GRNT}  --$username exists on $servername. setting up for modify...${NOCT}\n\n"		
#				umatch=true
	echo "		usrchk=1" >> ./$InfoGrab
	echo "		fi" >> ./$InfoGrab
	echo "	elif [ \"\$idtypesrch\" == \"$IDtype\" ] && [ ! -z \"\`echo \$namesrch | grep -i \$fnamesrch\`\" ] && [ ! -z \"\`echo \$namesrch | grep -i \$lnamesrch\`\" ]; then" >> ./$InfoGrab
	echo "		# if name and employee type match, set up for modify." >> ./$InfoGrab
#			printf 	"${GRNT}  --$username exists on $servername. setting up for modify...${NOCT}\n\n"
#			umatch=true
	echo "  	usrchk=1" >> ./$InfoGrab
	echo "	else" >> ./$InfoGrab
	echo "		# skip server if username exists, but is not the same user." >> ./$InfoGrab
	echo "  	usrchk=2" >> ./$InfoGrab
	echo "	fi" >> ./$InfoGrab
	echo "else" >> ./$InfoGrab
	echo "  usrchk=0" >> ./$InfoGrab				
	echo "fi" >> ./$InfoGrab
	echo "" >> ./$InfoGrab

	echo "# gather info for server." >> ./$InfoGrab	
#	printf "${YELT}Gather info from '${NOCT}$servername${YELT}'...${NOCT}\n"
#	printf "${GRNT}  -- grabbing OS type.${NOCT}\n"
	echo "OS=\"\`uname\`\"" >> ./$InfoGrab 
#	printf "${GRNT}  -- checking for group 'staff'.${NOCT}\n"
	echo "staff=\"\`cat /etc/group | grep -w staff | cut -d\":\" -f1\`\"" >> ./$InfoGrab
#	printf "${GRNT}  -- checking for group 'users'.${NOCT}\n"
	echo "users=\"\`cat /etc/group | grep users | cut -d\":\" -f1\`\"" >> ./$InfoGrab
#	printf "${GRNT}  -- checking for group 'ssh_access'.${NOCT}\n"
	echo "ssh=\"\`cat /etc/group | grep -w ssh_access | cut -d\":\" -f1\`\"" >> ./$InfoGrab
	echo "udir=\"\`cat /etc/passwd | grep \$USER | cut -d\":\" -f6\`\"" >> ./$InfoGrab
	echo "" >> ./$InfoGrab
	echo "# echo back the results of script. " >> ./$InfoGrab
	echo "echo \"\$usrchk:\$OS:\$staff:\$users:\$ssh:\$udir:\"" >> ./$InfoGrab


	printf "${YELT}checking if user exists, and grabbing info on '${NOCT}$servername${YELT}'...${NOCT}\n"
	scp ./$InfoGrab $servername:/tmp/$InfoGrab

	#check if server is reachable. if not, add to list and skip
	if [ "$?" == "1" ]; then
		printf "${REDT}!!ERROR!! ${YELT} Unable to reach '${NOCT}$servername${YELT}'.${NOCT}\n"
		printf "${YELT}Adding server to '${NOCT}$error_srv${YELT}'.${NOCT}\n\n"
		rm ./$InfoGrab
		echo "$servername" >> ./$error_srv
		echo "" 
		continue
	fi

	Info=$(ssh -t $servername "chmod u+x /tmp/$InfoGrab; PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin /tmp/$InfoGrab; rm /tmp/$InfoGrab")

	usrchk="`echo $Info | cut -d ":" -f1`"
	OS="`echo $Info | cut -d ":" -f2`"
	staff="`echo $Info | cut -d ":" -f3`"
	users="`echo ''`" # $Info | cut -d ":" -f4`"
	ssh="`echo $Info | cut -d ":" -f5`"
	udir="`echo $Info | cut -d ":" -f6`"

	if [ $usrchk -eq 0 ]; then
		printf "${GRNT}  --$username does not exist, continuing with create...${NOCT}\n\n"
		umatch=false
	elif [ $usrchk -eq 1 ]; then
		printf 	"${GRNT}  --$username exists on $servername. setting up for modify...${NOCT}\n\n"
		umatch=true
	elif [ $usrchk -eq 2 ]; then
		printf "${REDT} --$username already exists, and is not the same user.${NOCT}\n"
		printf "${PRPT} skipping server and adding it to '${NOCT}$username.change_id${PRPT}'.${NOCT}\n\n"

		# check if log file exists, if not, create.
		if [ ! -e "./$username.change_id" ]; then
			touch "./$username.change_id"
			echo "# These servers are where $username needs to be changed since it's" >> ./$username.change_id
			echo "# already in use on the following servers." >> ./$username.change_id
		fi
		# add server to log file and continue
		echo "$servername" >> ./$username.change_id
		echo ""
		continue
	else
		printf "${REDT} --Error: unable to read user info.${NOCT}\n"
		printf "${YELT}  --Adding server to '${NOCT}$error_srv${YELT}'.${NOCT}\n\n"
		echo "$servername" >> ./$error_srv
		continue
	fi

	# if the server is SunOS, then a directory will need to be setup as well, this will setup the new directory for the user.
	ndir=""
	if [ ! -z $udir ] && [ -z "`echo $udir | grep -i 'export'`" ]; then
		par1=`echo $udir | cut -d "/" -f2`
		ndir="/$par1/$username"
	else
		par1=`echo $udir | cut -d "/" -f2`
		par2=`echo $udir | cut -d "/" -f3`
		ndir="/$par1/$par2/$username"
	fi
	
	# if user exists, then grab groups, and ask user if they want to keep the groups 
		### Add section later ###
	
	
	##!!!## ADD LATER ##!!!## run check to make sure primary and secondary groups exists.

	# check if ssh_access, users, or staff exist, and create secondary groups variable.
	if $umatch; then
		printf "${YELT}Making final preperations for ID modification on '${NOCT}$servername${YELT}'...${NOCT}\n"
	else
		printf "${YELT}Making final preperations for ID creation on '${NOCT}$servername${YELT}'...${NOCT}\n"
	fi 

	# set up users with ssh access
	# be sure to look for ssh_access in sgroups...

	#!!!!!!!!! may need fix... !!!!!!!!!!!!!!!!!!
	tmpsgroup="$sgroup"
	if [ -z "$users" ]; then
		echo ""
	else
		if [ -z "`echo $tmpsgroup`" ]; then
			tmpsgroup="$users"
		else
			tmpsgroup="$tmpsgroup,$users"
		fi
	fi
	if [ -z "$staff" ]; then
		echo ""
	else
		if [ -z "`echo $tmpsgroup`" ]; then
			tmpsgroup="staff"
		else 
			tmpsgroup="$tmpsgroup,staff"
		fi
	fi
	if [ -z "$ssh" ]; then
		echo ""
	else
		if [ -z "`echo $tmpsgroup`" ]; then
			tmpsgroup="ssh_access"
		else
			tmpsgroup="$tmpsgroup,ssh_access"
		fi
	fi


	# start building script
	#intialize variable for groups to be written to.
	groupadd=""
	if [ ! -z `echo $OS | grep -i AIX` ]; then
		if [ ! -z "$pgroup" ]; then
			groupadd="pgrp=$pgroup "
		fi
	
		if [ ! -z "$pgroup" ] && [ ! -z "$tmpsgroup" ]; then
			groupadd="${groupadd}groups=$tmpsgroup "
		elif [ -z "$pgroup" ] && [ ! -z "$tmpsgroup" ]; then
			groupadd="groups=$tmpsgroup "
		fi			
	else
		if [ ! -z "$pgroup" ]; then
			groupadd="-g $pgroup "
		fi
	
		if [ ! -z "$pgroup" ] && [ ! -z "$tmpsgroup" ]; then
			groupadd="$groupadd-G $tmpsgroup "
		elif [ -z "$pgroup" ] && [ ! -z "$tmpsgroup" ]; then
			groupadd="-G $tmpsgroup "
		fi
	fi

	IDscript="$servername.$username.sh"
	touch $IDscript
	echo "#!/bin/bash" >> $IDscript
	echo "" >> $IDscript
	echo "# script to create ID for $username on $servername." >> $IDscript
	echo "" >> $IDscript
	
	if $umatch; then #if user exists on server.
		shopt -s nocasematch
	
		#query server side for geccos info.
		echo "comments=\"\`grep -i $username /etc/passwd | cut -d ':' -f5\`\"" >> $IDscript
		echo "" >> $IDscript
		echo "Enter your sudo password:" >> $IDscript
	
		case $OS in
			*SunOS*)
				#CrPrGrp="$sudo /usr/sbin/groupadd $NewGroup";
				echo "sudo /usr/sbin/usermod -c \"\$comments MD=$info\" $groupadd$username" >> $IDscript;
				echo "sudo passwd $username" >> $IDscript;
				echo "sudo passwd -f $username" >> $IDscript;;
			*Linux*)
				#CrPrGrp="$sudo /usr/sbin/groupadd $NewGroup";
				echo "sudo /usr/sbin/usermod -c \"\$comments MD=$info\" $groupadd$username" >> $IDscript;
				echo "sudo passwd $username" >> $IDscript;	
				echo "sudo chage -d 0 $username" >> $IDscript;;
			*AIX*)
				#CrPrGrp="$sudo /usr/sbin/groupadd $NewGroup";
				echo "sudo chuser gecos=\"\$comments MD=$info\" $groupadd$username" >> $IDscript;
				echo "sudo passwd $username" >> $IDscript;
				echo "sudo pwdadm -f ADMCHG $username" >> $IDscript;;		
		esac
	
	else #if user does NOT exist on server.
		shopt -s nocasematch
	
		case $OS in
			*SunOS*)
			#CrPrGrp="$sudo /usr/sbin/groupadd $NewGroup";
				echo "sudo /usr/sbin/useradd -d $ndir -m -c '897/$IDtype/$serial/$agency/$name CD=$info' $groupadd$username" >> $IDscript;
				echo "sudo passwd $username" >> $IDscript;
				echo "sudo passwd -f $username" >> $IDscript;;
			*Linux*)
				#CrPrGrp="$sudo /usr/sbin/groupadd $NewGroup";
				echo "sudo /usr/sbin/useradd -d $ndir -m -c '897/$IDtype/$serial/$agency/$name CD=$info' $groupadd$username" >> $IDscript;
				echo "sudo passwd $username" >> $IDscript;	
				echo "sudo chage -d 0 $username" >> $IDscript;;
			*AIX*)
				#CrPrGrp="$sudo /usr/sbin/groupadd $NewGroup";
				echo "sudo mkuser gecos='897/$IDtype/$serial/$agency/$name CD=$info' $groupadd$username" >> $IDscript;
				echo "sudo passwd $username" >> $IDscript;
				echo "sudo pwdadm -f ADMCHG $username" >> $IDscript;;		
		esac

	fi 
	
	#copy ID creation script to target server
	echo ""
	if [ -e "./$IDscript" ]; then
		printf "${YELT}Copying ID Creation script to '${NOCT}$servername${YELT}'...${NOCT}\n"
		scp $IDscript $servername:/tmp/$IDscript
		printf "${YELT}Executing ID Creation script on '${NOCT}$servername${YELT}'...${NOCT}\n"
		ssh -t $servername "chmod u+x /tmp/$IDscript; PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin /tmp/$IDscript; rm /tmp/$IDscript"
	fi
	echo ""
	#delete script on local machine	
	rm ./$IDscript ./$InfoGrab

	# check if user was created successfully
	if $umatch; then
		echo ""
	else
		printf "${YELT}Checking if '${NOCT}$username${YELT}' was successfully created on '${NOCT}$servername${YELT}'...${NOCT}\n"
		if [ ! -z "`ssh -t -q $servername "grep -i $username /etc/passwd"`" ]; then
			printf "${GRNT}  --Success!${NOCT}\n\n"
			echo ""
		else
			printf "${REDT}  --Failure!${NOCT}\n"
			printf "${YELT}  --Adding server to '${NOCT}$error_srv${YELT}'.${NOCT}\n\n"
			echo "$servername" >> ./$error_srv
			echo ""
		fi
	fi
	

done 3< $SOURCEFILE

printf "${YELT}Finished with ID Creation.${NOCT}\n"
printf "${YELT}Make sure to check '${NOCT}$error_srv${YELT}' for any failed servers.${NOCT}\n\n"

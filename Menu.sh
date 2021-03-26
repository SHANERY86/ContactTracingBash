#!/bin/bash

#this script presents the user with the menu for navigating the scripts

buffer=`echo "$PWD/buffer.txt"`   #buffer files can be created in the different scripts, this creates a variable with their directory location to perform a check if they are present later"
buffer2=`echo "$PWD/buffer2.txt"`
buffer3=`echo "$PWD/buffer3.txt"`

echo "Welcome to your friendly Covid-19 Tracing Tool" #the menu is presented as seen here
echo "Please select from one of the following options"
echo "1) Add a new contact"
echo "2) Remove a contact"
echo "3) Search for a contact"
echo "4) Mail a contact"
echo "5) Exit"

read response
	if [[ "$response" =~ [1-5] ]] #the input must consist of numbers 1 through 5
	then
		case $response in
			1) ./addContact.sh;;  #runs the addContact script
			2) ./Remove.sh;; #runs the remove script
			3) ./Search.sh;; #runs the search script
			4) ./mail.sh;; #runs the mail script
			5) 
			if [ -f "$buffer" ]   #checks for the presence of buffer files and removes them if located
			then
        			rm buffer.txt
			fi
			if [ -f "$buffer2" ]
			then    
        			rm buffer2.txt
			fi
			if [ -f "$buffer3" ]
			then
        			rm buffer3.txt
			fi
			exit;;
		esac
	else
		echo "Invalid input. Please enter an input between 1 and 5. Press enter to continue"
		read key
		./Menu.sh
	fi

#!/bin/bash

#this script allows the user to search for a contact via any of the contact fields: name, number, address, email

echo "Please enter a search term, enter 'all' to view entire list, or input 'menu' to return to the main menu"
correctInput=false
while [ "$correctInput" = "false" ]
	do
		read input
		lowerInput=`echo "$input" | awk '{print tolower($0)}'`  #variable to ensure case insensitive operation
		result=`grep -i "$input" ContactDetails.txt | sed 's/;/ /g'` #filters contents of ContactDetails.txt with the search input terms
		resultCount=`grep -i "$input" ContactDetails.txt | awk '{variable+=1} END {print variable}'`
		if [ "$lowerInput" = "menu" ]
		then
			./Menu.sh
		exit
		fi
		if [ "$input" = "" ]
		then
			echo "Blank search term entered, please enter something to search for"
		fi
		if [[ "$input" =~ [a-z] ]] || [[ "$input" =~ [0-9] ]] && [ "$input" != "all" ] && [ "$result" != "" ] #any combination of letters or numbers accepted
		then
			correctInput=true
			echo ""
			echo ""$resultCount" entries found"
			echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
			echo "NAME		      ADDRESS                       			                                PHONE NO. 		  EMAIL"
			echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
			echo "$result" #prints list of entries found using search terms
			echo ""
		fi
		if [ "$lowerInput" = "all" ]
			then
			correctInput=true
                	echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
                	echo "NAME		      ADDRESS                                                                           PHONE NO.                 EMAIL"
                	echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
			grep "" ContactDetails.txt | sed 's/;/ /g' #prints entire contents of ContactDetails.txt
			echo ""
		fi
		if [ "$result" = "" ] && [ "$input" != "all" ]
			then
			echo "Nothing found, please try again, or input 'menu' to return to the main menu"
		fi
	done
echo "Press enter to return to the main menu, or input s to search again"
read key
	if [[ "$key" = [Ss] ]] #if user enters s, this script will run again
	then
	./Search.sh
	exit
	fi
./Menu.sh


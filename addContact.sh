#!/bin/bash
echo "Enter New Contact Name, or input 'menu' to return to the main menu"

nameInput=false #this is a variable used as a boolean, it must be set to true to proceed past the first while loop.

while [ "$nameInput" = "false" ]  #The script will loop within this while loop and the user cannot proceed, unless the correct criteria for name input is satisfied and the nameInput variable is set to 'true' 
	do

	read name
	nameLength=`echo "$name" | awk '{print length}'` #this command uses awk to output the character length of the input that the user enters for a name
	lowerName=`echo "$name" | awk '{print tolower($0)}'` #this command will take the input and make it all lower case, for the case of the user entering 'menu', allowing this case to trigger no matter what case the user inputs

		if [ "$lowerName" = "menu" ] #if user inputs 'menu', in any combination of upper or lower case, the main menu scripts runs to take them back to the main menu
			then
			./Menu.sh
			exit
		fi
		if [ "$name" = "" ] #if the user inputs nothing, they get prompted with the message within this if statement
			then
			echo "Cannot input blank name, please try again, or input 'menu' to return to the main menu"
		fi
		if [[ "$name" =~ [a-zA-Z] ]] && [ "$nameLength" -le 20 ] && [ "$nameLength" -gt 4 ] #this satisfies the correct criteria for name input, consists of lower and/or uppercase letters and is appropriate length.
			then
			nameInput=true #when this is set as 'true' the script will proceed past this while loop
		fi
		if [ "$nameLength" -gt 20 ] #if the name the user inputs is larger than 20 characters they are prompted with this message
		then
			echo "Name length must not exceed 20 characters"
		fi
		if [ "$nameLength" -lt 4 ] && [ "$name" != "" ] #if the name is less than 4 characters long the user is prompted with this message
		then
			echo "Name length must be at least 5 characters long"
		fi

	name=`echo -e "$name                "`   #the name is appended with trailing blank spaces for formatting purposes, so the name will sit appropriately in the contact list table.

	done  #while loop complete 

echo "Enter Address, or input 'menu' to return to the main menu" #the code pattern is similar for the rest of the input fields, address, phone number and email

addressInput=false

while [ "$addressInput" = "false" ]
	do

	read address
	addressLength=`echo "$address" | awk '{print length}'`
        lowerAddress=`echo "$address" | awk '{print tolower($0)}'`

        	if [ "$lowerAddress" = "menu" ]
        		then
        		./Menu.sh
			exit
        	fi
                if [ "$address" = "" ]
                        then
                        echo "Cannot input blank address, please try again, or input 'menu' to return to the main menu"
                fi
		if [[ "$address" =~ [a-zA-Z] ]] && [ "$addressLength" -le 80 ] && [ "$addressLength" -gt 4 ]
			then
			addressInput=true
		fi
                if [ "$addressLength" -gt 80 ]
                then
                        echo "Address length must not exceed 80 characters"
                fi
                if [ "$addressLength" -lt 4 ] && [ "$address" != "" ]
                then
                        echo "Address length must be at least 5 characters long"
                fi

	address=`echo "$address                                                                           "`

	done

echo "Enter Mobile Phone Number, or input 'menu' to return to the main menu"
numberInput=false

while [ "$numberInput" = false ]

	do

	read number
	numberLength=`echo "$number" | awk '{print length}'`
        lowerNumber=`echo "$number" | awk '{print tolower($0)}'`

        	if [ "$lowerNumber" = "menu" ]
        		then
        		./Menu.sh
			exit
        	fi
                if [ "$number" = "" ]
                        then
                        echo "Cannot input blank mobile phone number, please try again, or input 'menu' to return to the main menu"
                fi
		if [[ "$number" =~ [a-zA-Z] ]] #this if statement will check if the user enters an input containing upper or lowercase letters, in which case they will be prompted with this message
			then
			echo "Phone number entry cannot be text string, please enter a number, or input 'menu' to return to the main menu"
		fi
		if [[ "$number" =~ [0-9] ]] && [ "$numberLength" -le 20 ] && [ "$numberLength" -gt 7 ]
			then
			numberInput="true"
		fi
                if [ "$numberLength" -gt 20 ]
                then
                        echo "Number length must not exceed 20 characters"
                fi
                if [ "$numberLength" -lt 7 ] && [ "$number" != "" ]
                then
                        echo "Number length must be at least 5 characters long"
                fi

	number=`echo "$number             "`

	done

echo "Enter e-mail address, or input 'menu' to return to the main menu"

emailInput=false

while [ "$emailInput" = "false" ]

	do

	read email
	emailLength=`echo "$email" | awk '{print length}'`
        lowerEmail=`echo "$email" | awk '{print tolower($0)}'`

        	if [ "$lowerEmail" = "menu" ]
        		then
        		./Menu.sh
			exit
        	fi
                if [ "$email" = "" ]
                        then
                        echo "Cannot input blank e-mail address, please try again, or input 'menu' to return to the main menu"
                fi
		if [[ "$email" =~ [a-zA-Z] ]] && [ "$emailLength" -le 40 ] && [ "$emailLength" -gt 6 ] 
			then
			emailInput=true
		fi
                if [ "$emailLength" -gt 40 ]
                then
                        echo "Email length must not exceed 40 characters"
                fi
                if [ "$emailLength" -lt 7 ] && [ "$email" != "" ]
                then
                        echo "Email length must be at least 7 characters long"
                fi

	email=`echo "$email                                 "`

	done

echo -e "${name:0:20}; ${address:0:80}; ${number:0:20}\t; ${email:0:40}" >> ContactDetails.txt  #the details are added to a new entry to the ContactDetails.txt,but truncated to a size to fit nicely into the list table

echo "New Contact Added! Press enter to return to the main menu, or input 'C' to add another contact"

read key
	if [[ "$key" =~ [Cc] ]]  #if user inputs 'c', this script will begin again, it can be upper or lower case
		then
		./addContact.sh  #this will begin this script again
		exit
	fi
./Menu.sh #this will run the main menu script again

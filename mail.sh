#!/bin/bash

#this script prompts user to search contact list by their emails, and can send emails to their chosen recipients from the search results

echo "Please enter the email address you would like to send an email to, input 'all' to see all contacts, or input 'menu' to return to the main menu"
emailFound=false
while [ "$emailFound" = "false" ] 
	do
		read input
		lowerInput=`echo "$input" | awk '{print tolower($0)}'`

		if [ "$input" = "" ] && [ "$lowerInput" != "all" ] && [ "$lowerInput" != "menu" ]
			then
			echo "Email search term cannot be blank, please try again"
			else 
			result=`awk -F';' '{print $4}' ContactDetails.txt | grep "$input"` #searches column 4 of the text file which is the column of emails
               			if [ "$result" = "" ] && [ "$lowerInput" != "all" ] && [ "$lowerInput" != "menu" ]
                        	then
                        	echo "No email found, please try again, or input 'menu' to return to the main menu" 
				else
				emailFound=true
				fi
		fi
		if [ "$lowerInput" = "all" ]
			then
			result=`awk -F';' '{print $4}' ContactDetails.txt`
			emailFound=true
			fi
		if [ "$lowerInput" = "menu" ]
			then
			./Menu.sh
			exit
			fi
	done

grep -i "$result" ContactDetails.txt > buffer.txt #this prints the contacts that are related to the emails found with the search results to buffer.txt
buffer=`echo "$PWD/buffer.txt"`
awk -F';' '{print NR,$1,$4}' buffer.txt #the name column and email address column of the contacts that are related to the search terms are presented
echo "Select the appropriate person to email by entering the row number, input 'all' to mail all contacts, or input 'menu' to return to main menu"
correctInput=false
while [ "$correctInput" = "false" ]
do
	read number
	lowerNumber=`echo "$number" | awk '{print tolower($0)}'`

	if [[ "$number" =~ [0-9] ]] #the user has selected the person to email by the row number
		then
		correctInput=true
		selectedPerson=`awk 'NR=='$number' {print NR,$0}' buffer.txt | sed "s/$number//" | sed -e 's/^ //'` #the contact details for that person are put into this variable selectedPerson
		echo "$selectedPerson" > buffer2.txt #these details are forwarded to buffer2.txt
		buffer2=`echo "$PWD/buffer2.txt"`
		echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
		echo "NAME                  ADDRESS                                                                           PHONE NO.                 EMAIL"
		echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
		echo "$selectedPerson" | sed 's/;/ /g' #prints details of person, eliminating field separators
		echo ""
		echo "Email this person? (y/n) If you would like to add another recipient, input the appropriate row number"
		elif [ "$number" != "all" ]
		then
		echo "Please input an integer"
	fi
		if [ "$lowerNumber" = "all" ] 
		then
		correctInput=true
		echo "Email all contacts? (y/n)"
		cat ContactDetails.txt > buffer2.txt #forwards all contact details to buffer2.txt
		fi
		if [ "$lowerNumber" = "menu" ]
		then
		if [ -f "$buffer" ]
        	then
            		rm buffer.txt
		fi
		if [ -f "$buffer2" ]
        		then
            		rm buffer2.txt
		fi
		./Menu.sh
		exit
	fi
done
correctResponse=false
yorn=false
while [ "$correctResponse" = "false" ]
do
read response
	if [[ "$response" =~ [0-9] ]] #the user has chosen to add an additional person to the list of recipients
		then
		yorn=true
		selectedPerson2=`awk 'NR=='$response' {print NR,$0}' buffer.txt | sed "s/$response//" | sed -e 's/^ //'` 
		echo "$selectedPerson2" >> buffer2.txt #this additional person is added to the list in buffer2.txt
		echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
		echo "NAME                  ADDRESS                                                                           PHONE NO.                 EMAIL"
		echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
		awk '{print $0}' buffer2.txt | sed 's/;/ /g' #list of contacts in buffer2.txt printed elmininating field separators
		echo ""
		echo "Email these people? (y/n) If you would like to add another recipient, input the appropriate row number"
	fi
	if [[ "$response" =~ [Yy] ]]
	then
		correctResponse=true
		emails=`awk -F';' '{print $4}' buffer2.txt | sed -e 's/^ //'` #outputs contents of email column in buffer2.txt to a variable called emails, these are the emails which will recieve the message 
		echo "Enter the email subject"
		read subject
		echo "Enter the email message"
		read message
		echo $message | mail -s $subject $emails
		echo "Email sent" `date`
		yorn=true
	fi
	if [[ "$response" =~ [Nn] ]]
	then
		correctResponse=true
		echo "Email cancelled"
		yorn=true
	fi
	if [ "$yorn" = "false" ]
	then
		echo "Please enter Y or N, or the number of a new recipient"
	fi
done
if [ -f "$buffer" ]
       then
            rm buffer.txt
fi
if [ -f "$buffer2" ]
       then
            rm buffer2.txt
fi
echo "Press enter to return to the main menu, or input 'm' to mail another contact"
read key
if [[ "$key" =~ [Mm] ]]
then
./mail.sh
else
./Menu.sh
fi

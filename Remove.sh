#!/bin/bash
echo "Please enter a search term for a users name, input 'all' to see all Contacts, or input 'menu' to return to the main menu"
resultFound=false
cat ContactDetails.txt > ContactsBuffer.txt
#this script prompts the user to enter a search term for a contacts NAME ONLY

while [ "$resultFound" = "false" ] #this while loop will prevent the script from progressing until the user inputs the appropriate search term
	do
		read name
		lowerName=`echo "$name" | awk '{print tolower($0)}'` #this converts whatever is input to lowercase in case the user attempts to enter a command in higher case
		if [ "$lowerName" = "menu" ] 
			then
			./Menu.sh #return to menu if menu is entered into the command line
			exit
		fi
		if [ "$lowerName" = "all" ] 
			then
			result=`awk '{print $0}' ContactDetails.txt` #prints the entire contact details file in the case the user inputs all 
			else if [[ "$name" =~ [a-z] ]]
			then 
                        result=`awk -F";" '{print $1}' ContactDetails.txt | grep -i "$name"` #this uses awk to print the name column of the contact details file, and then uses grep to filter that column with the search term entered
                        fi
		fi
		if [ "$name" = "" ] 
			then
			echo "Blank input entered"
			fi
                if [ "$result" = "" ]
                        then
                        echo "No results found, please try again, or input 'menu' to return to the main menu"
                        else
                        resultFound=true
                        fi
	done

grep "$result" ContactDetails.txt | awk '{print NR,$0}' > buffer.txt #the contents of the search results are moved to a buffer.txt file, with the addition of row numbers added using the awk NR variable

#the buffer files are meant to be temporary files and will be deleted at the appropriate stage of the script before it ends.

buffer="$PWD/buffer.txt" #the buffer file directory location is fed to a variable in order to check for its existence for deletion later

echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"   #this is a header for the contact list
echo "# NAME		        ADDRESS                                                                           PHONE NO.               EMAIL"
echo "---------------------------------------------------------------------------------------------------------------------------------------------------------"

awk '{print $0}' buffer.txt | sed 's/;/ /g'  #this prints the contents of buffer.txt, which is our search results with the inlcusion of row numbers, but removes the field separators 
echo ""

listCount=`awk '{variable+=1} END {print variable}' buffer.txt` #this will output the number of rows in the buffer.txt file 
correctInput=false
if [ "$listCount" -eq 1 ] #if the number of rows is 1, this means the number of matches is 1, and the user has a simple yes or no prompt to delete that entry
	then
		echo "Are you sure you want to delete this entry?(y/n)"
		selectedEntry=`awk '{print $0}' buffer.txt | sed -e 's/^[0-9]//' | sed -e 's/^ //' | sed 's/;/ /g'`
		correctInput=true
	else
	echo "Please enter line number to delete entry, input 'all' to delete all, or input 'menu' to return to the main menu" #if there is more than 1 result, the user is prompted to enter a line number to select an entry to delete
fi
while [ "$correctInput" = false ] #while loop to prevent the script from proceeding unless the appropriate input is entered
        do
		read number
		lowerNumber=`echo "$number" | awk '{print tolower($0)}'` #variable with input converted to lower case to allow for case insensitive input for text commands
			if [ "$lowerNumber" = "menu" ]
                	then
				if [ -f "$buffer" ] #checks for existence of a temporary buffer file, and if its there, deletes it before ending the script
				then
				rm buffer.txt #removes the buffer.txt file as the user has entered menu command to end script and return to main menu
               			fi
			./Menu.sh #back to main menu as user has entered the menu command
                	exit
        		fi
        	if [ "$lowerNumber" = "all" ] #the user has entered the all command to delete the full list of search results
                	then
			correctInput=true
                	selectedEntry=`awk -F';' '{print $0}' buffer.txt | sed -e 's/^[0-9]//' | sed -e 's/^ //' | sed 's/;/ /g'` #this prints contents of buffer.txt, which is the full list of search results, but removes the 
																  #row numbers and field separators, and appends it to the variable selectedEntry
			awk '{print $0}' ContactDetails.txt | sed 's/;/ /g' > buffer.txt #replaces the contents of the original buffer.txt file with the current contacts in the database 
			echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
			echo "NAME                  ADDRESS                                                                           PHONE NO.                 EMAIL"
			echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
			echo "$selectedEntry" #this prints the full list of results without row numbers and field separators
			echo "" 
                	echo "Are you sure you wish to delete these entries?(y/n)"
        	fi
		if [[ "$number" =~ [0-9] ]] #the user has selected an entry from the list of search results to delete by entering a number
			then
				if [ "$number" -le "$listCount" ] #a check to ensure the number input is less than or equal to the number of rows of results and hence is a row number that exists
					then 
						correctNumber=true 
					else
						echo "Entry number "$number" does not exist, please try again"
				fi
				if [ "$correctNumber" = "true" ] #when the script is satisfied the user has entered a line number that exists
					then
						correctInput=true
						selectedEntry=`awk 'NR=='$number' {print $0}' buffer.txt | sed "s/$number//" | sed -e 's/^ //' | sed 's/;/ /g'` #this prints the selected row of buffer.txt (buffer.txt is the full list
																				#of search results). This also removes the leading row number and the 
																				#spaces and field separators
						echo "$selectedEntry" > buffer2.txt #moves the contents of the selectedEntry variable to a new temporary file, buffer2.txt
						buffer2="$PWD/buffer2.txt" #appends the directory location of this temporary file for a check for its existence later
						awk '{print $0}' ContactDetails.txt | sed 's/;/ /g' > buffer.txt #replaces the contents of the original buffer.txt file with the current contacts in the database
						echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
                				echo "NAME                  ADDRESS                                                                           PHONE NO.                 EMAIL"
                				echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
						echo "$selectedEntry" #displays the current entries selected for deletion
						echo ""
						echo "Are you sure you wish to delete this entry?(y/n) If you wish to add another entry to delete, input that number now." 
				fi
		elif [ "$number" != "all" ] #if the user enters an input which is not an integer 0-9 or is not the all command
			then
			echo "Please enter an integer, or input 'menu' to return to the main menu"
		fi
	done
correctInput2=false
while [ "$correctInput2" = false ] #this loop is waiting for the user to input the appropriate response, either Y or N for deletion, or input another number to add that to the list for deletion
	do
		read response
		if [[ "$response" =~ [Yy] ]]
			then
			correctInput2=true
			deleteTerm1=`echo "$selectedEntry" | awk '{print $1}'`
			deleteTerm2=`echo "$selectedEntry" | awk '{print $3}'`
			grep -v "$deleteTerm1.*$deleteTerm2" ContactsBuffer.txt > ContactDetails.txt #this is the command that will perform the final deletion of the entries in the actual ContactDetails.txt file. It does a reverse grep in the buffer.txt
									 	#file. We have appended the current information of the ContactDetails file back to the buffer.txt file earlier, and a reverse grep using the 
										#selectedEntry variable will output the database without the entries selected which are in that variable. Appending that to the ContactDetails.txt
										#file will output the original ContactDetails.txt but without the entries selected by this script for deletion 
			rm buffer.txt
			rm ContactsBuffer.txt
			echo "Entry Deleted! Press enter to return to the main menu, or input 'd' to delete another contact"
		fi
		if [[ "$response" = [Nn] ]]
			then
			correctInput2=true
			echo "Deletion cancelled. Press enter to return to the main menu, or input 'd' to delete another contact"
		fi
		if [[ "$response" =~ [0-9] ]]  #the user has input a number instead of yes or no, which means they want to add another entry to the deletion list
			then
			addEntry=false
			while [ "$addEntry" = "false" ]
			do
				if [ "$response" -le "$listCount" ] #check to ensure the input number is within the boundaries of the number of entries presented
				then
					addEntry=true
					grep "$result" ContactDetails.txt | sed 's/;/ /g' > buffer3.txt #this appends the original list of results, without field separators, to a file buffer3.txt
					buffer3="$PWD/buffer3.txt" 
					awk 'NR=='$response' {print $0}' buffer3.txt >> buffer2.txt #this adds the latest selection to the list of currently selected entries to buffer2.txt
					selectedEntry=`awk '{print $0}' buffer2.txt` #this changes the selectedEntry variable to add the latest addition to the deletion list
					echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
                			echo "NAME                  ADDRESS                                                                           PHONE NO.                 EMAIL"
                			echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
					awk '{print $0}' buffer2.txt #prints all contents of buffer2.txt which is updated with the latest entry for deletion
					echo ""
					echo "Do you want to delete these entries? (y/n) If you wish to add another entry to delete, input that number now."
				else
					echo "Entry number "$response" does not exist, please try again"  #if user enters number that is not in the list
					read response
				fi
			done
		fi
		if [ "$correctInput2" = false ] && [ "$addEntry" = "false" ] #if user enters neither y or n, or a number to add to the list
			then
			echo "Please enter either 'y' or 'n'"
		fi
	done
read key
if [ -f "$buffer" ]  #when the script is done, it checks for the existence of temporary buffer files, and deletes them if they are present
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
	if [[ "$key" =~ [Dd] ]]  #if user enters d the script will run again
		then
		./Remove.sh
		exit
	fi
./Menu.sh

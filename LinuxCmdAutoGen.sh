#!/bin/bash

My_commands="grep info man find whoami hostname tty users chown watch sudo renice dirname"

System_Information="hostname uname"

User_Information="whoami users tty"

File_and_Directory_Operations="find dirname chown"

System_Monitoring_and_Resource_Management="watch sudo renice"

System_Information_and_Configuration="grep info"

for command in $My_commands; do
    Description=$(man "$command" | awk -v RS= '/^DESCRIPTION/ {sub(/^DESCRIPTION/, ""); print}')

    Version_History=$("$command" --version 2>&1 | head -n 1)
    
    
    Example=$(man "$command" | grep -A 5 -E '^(EXAMPLES)' | grep -v -E '^(EXAMPLE|EXAMPLES)')



    if [  "$command" = "grep" ]; then     
          Example=$(man "$command" | grep -A 9 '^EXAMPLE' | grep -v  '^EXAMPLE')        
    fi 
    
    if [ -z "$Example" ]; then
          
          Example="$command"         
    fi 
    
    
    Related_Commands=$(compgen -c | grep "$command" | head -n 5)

    {
           echo "       -------------------       "
           echo -e "            \033[1mCommand:\033[0m"
           echo "              $command"   
           echo "       -------------------       "
           echo "____________     ________________________________________________________"
           echo -e "\033[1mDescription\033[0m"
           echo "____________"  
           echo "                 $Description"
           echo "_____________________________________________________________________"
           echo
           echo "_________________    __________________________________________________"
           echo -e "\033[1mVersion History\033[0m"
           echo "_________________"
           echo "                     $Version_History"
           echo
           echo "___________________________________________________________________"
           echo
           echo "_______        _______________________________________________"
           echo -e "\033[1mExample\033[0m"
           echo "_______"
           echo "$Example"
           echo
           echo "___________________________________________________________________"
           echo
           echo "________________        _______________________________________________"
           echo -e "\033[1mRelated Commands\033[1m"
           echo "________________"
           for related in $Related_Commands;do
           echo "                        "$related" "
           done
           echo
           echo "___________________________________________________________________"
           echo
    } > "${command}.txt"



done
while true
do
    echo 
    echo "Available commands:"
    echo "$My_commands" | tr ' ' '\n'
    read -p "Chose one of the above commands or type 'e' to exit: " User_input
    if [ "$User_input" = "e" ]; then
        echo "Exitting..."
        exit 0
    fi

    exist=false

    for command in $My_commands 
    do 
        if [ "$User_input" = "$command" ]; then
           exist=true 
           break
        fi    
    done

    if [ "$exist" = false ]; then
        echo "Error:please enter a valid command"
        continue 
    fi    

    read -p "Do you wnat to check the manual for '"$User_input"' ? [y/n] " choice 

    if [ "$choice" = "y" ]; then
       cat "${User_input}.txt"
    elif [ "$choice" != "n" ]; then
         echo "Error:Invalid choice, returning to the start point... "
         continue  
    fi 

    echo
    echo
    
    read -p "Do you wnat to verify the manual for the command ("$User_input")? [y/n] " verification  

    if [ "$verification" = "y" ]; then
     
        Description=$(man "$command" | awk -v RS= '/^DESCRIPTION/ {sub(/^DESCRIPTION/, ""); print}')

        Version_History=$("$command" --version 2>&1 | head -n 1)
    
    
        Example=$(man "$command" | grep -A 5 -E '^(EXAMPLES)' | grep -v -E '^(EXAMPLE|EXAMPLES)')



        if [  "$command" = "grep" ]; then     
           Example=$(man "$command" | grep -A 9 '^EXAMPLE' | grep -v  '^EXAMPLE')        
        fi 
    
        if [ -z "$Example" ]; then
          
          Example="$command"         
        fi 
    
    
        Related_Commands=$(compgen -c | grep "$command" | head -n 5)
        {
           echo "       -------------------       "
           echo -e "            \033[1mCommand:\033[0m"
           echo "              $command"   
           echo "       -------------------       "
           echo "____________     ________________________________________________________"
           echo -e "\033[1mDescription\033[0m"
           echo "____________"  
           echo "                 $Description"
           echo "_____________________________________________________________________"
           echo
           echo "_________________    __________________________________________________"
           echo -e "\033[1mVersion History\033[0m"
           echo "_________________"
           echo "                     $Version_History"
           echo
           echo "___________________________________________________________________"
           echo
           echo "_______        _______________________________________________"
           echo -e "\033[1mExample\033[0m"
           echo "_______"
           echo "$Example"
           echo
           echo "___________________________________________________________________"
           echo
           echo "________________        _______________________________________________"
           echo -e "\033[1mRelated Commands\033[1m"
           echo "________________"
           for related in $Related_Commands;do
           echo "                        "$related" "
           done
           echo
           echo "___________________________________________________________________"
           echo
        } > "${User_input1}.txt"




        differences=$(diff "${User_input}.txt" "${User_input1}.txt")
   
        if [ -z "$differences" ]; then
           echo "PASS, ther's no difference between the original manual and the created manual for "$User_input"."
        else
           echo "FAILED,there'r one or more differecne between the original manula and the created manual for "$User_input": "
           echo "$differences"    
        
           fi  
    elif [ "$verification" != "n" ]; then
         echo "Error:Invalid choice, returning to the start point... "
         continue  
    fi
    
    echo
    echo
        
    if echo "$System_Information" | tr ' ' '\n' | grep -q "$User_input"; then
         echo "Recomanded commands for System Information"
         echo "$System_Information" | tr ' ' '\n'
    fi

    if echo "$User_Information" | tr ' ' '\n' | grep -q "$User_input"; then
       echo "Recomanded commands for User Information"
       echo "$User_Information" | tr ' ' '\n'
    fi

    if echo "$File_and_Directory_Operations" | tr ' ' '\n' | grep -q "$User_input"; then
       echo "Recomanded commands for File and Directory Operations"
       echo "$File_and_Directory_Operations" | tr ' ' '\n'
    fi

    if echo "$System_Monitoring_and_Resource_Management" | tr ' ' '\n' | grep -q "$User_input"; then
       echo "Recomanded commands for System Monitoring and Resource Management"
       echo "$System_Monitoring_and_Resource_Management" | tr ' ' '\n'
    fi

    if echo "$System_Information_and_Configuration" | tr ' ' '\n' | grep -q "$User_input"; then
       echo "Recomanded commands for System Information and Configuration"
       echo "$System_Information_and_Configuration" | tr ' ' '\n'
    fi
    
    
    echo 
    echo
    
    
    echo "Searching progress :"

    read -p "Is there a specific word you want to search for? [y/n]: " searching

    if [ "$searching" = 'y' ]; then
       read -p "Enter a word to search for: " word
       word_exists=false
       for Command in $My_commands; do
          if grep -q "$word" "$Command.txt"; then 
          echo "The word exists in "$Command"'s manula"
          word_exists=true 
          fi
       done
       
       echo
       echo
       if [ "$word_exists" = false ]; then
       echo "No commands found with the specified word in thier manual."
       fi    
    

    elif [ "$searching" != 'n' ]; then
         echo "Error:Invalid choice, returning to the start point... "
         continue  
    fi



    echo
    
    echo "Available commands:"
    echo "$My_commands" | tr ' ' '\n'
    read -p "Do you want to search for a specific command from these available commands? [y/n]: " searching1

    if [ "$searching1" = 'y' ]; then
       read -p "Enter the command that you want to search for: " cmd
       valid=false
       
       for com in $My_commands; do
        if [ "$cmd" = "$com" ]; then
           
           valid=true 
           break
        fi    
       done

       if [ "$valid" = "false" ]; then
          echo "Error:Invalid choice, returning to the start point... "
          continue 
       fi
        
       read -p "What do you want to search for in the command \"$cmd\" :
1) Description
2) Version History
3) Example
4) Related commands
Enter your choice: " searching_choice
       
       
    
       case "$searching_choice" in
           1) 
              Description_for_search=$(man "$command" | awk -v RS= '/^DESCRIPTION/ {sub(/^DESCRIPTION/, ""); print}')
              echo "$Description_for_search"
              ;;
           2) 
              Version_History_for_search=$("$cmd" --version 2>&1 | head -n 1) 
              echo "$Version_History_for_search"
              ;;
           3)
             Example_for_search=$(man "$cmd" | awk -v RS= '/^[Ee]XAMPLE[Ss]/ {gsub(/^[Ee]XAMPLE[Ss]\n/, ""); print}')

             if [ -z "$Example_for_search" ]; then
                 Example_for_search=$(man "$cmd" | awk -v RS= '/^EXAMPLE[Ss]/ {print}')
             fi
             if [ -z "$Example_for_search" ]; then
                 Example_for_search="$cmd"         
             fi 
             echo "$Example_for_search"
             ;;
           4) 
             Related_Commands_for_search=$(compgen -c | grep "$cmd")
             echo "$Related_Commands_for_search"
             ;;
           *) 
             echo "Error:Invalid choice, returning to the start point... "
             continue 
             ;;
       esac

    elif [ "$searching1" != 'n' ]; then
          echo "Error:Invalid choice, returning to the start point... "
          continue  
    fi
done



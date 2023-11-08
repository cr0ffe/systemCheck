#!/bin/bash

# Define the list of servers with descriptions
declare -A SERVERS=( ["xxx.xxx.xxx.xxx"]="desc 1" 
                     ["xxx.xxx.xxx.xxx"]="desc 2"
                     ["xxx.xxx.xxx.xxx"]="desc 3" )

# Define the email recipients
RECIPIENTS="person@address.com,person@address.com"  # Modify this with your desired recipients

# File to store ping results in the working directory
RESULTFILE="ping_results.txt"

# Clear previous results
> $RESULTFILE

# Ping each server and write the result with its description to the results file
for SERVER in "${!SERVERS[@]}"; do
    DESC=${SERVERS[$SERVER]}
    # Use ping with a timeout of 10 seconds. Adjust -c and -W as needed.
    # -c 1 means only one ping packet and -W 10 means a 10-second timeout.
    ping -c 1 -W 10 "$SERVER" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$SERVER ($DESC) is up" >> $RESULTFILE
    else
        echo "$SERVER ($DESC) is down" >> $RESULTFILE
    fi
done

# Append the note to the results file
echo -e "\nNote: Schedule the cronjob for this and add any notes you wish here" >> $RESULTFILE

# Send the email with the results
mail -s "Ping Report" "$RECIPIENTS" < $RESULTFILE

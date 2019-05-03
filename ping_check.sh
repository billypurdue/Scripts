#!/bin/bash

ping_targets="8.8.8.8" #Thing we are pinging
failed_hosts="" #Clear this out
down_file=/tmp/failed #File to create and check for so we don't spam ourselves
notify_number="XXXXXXXXXX"
now=`date '+%F_%H:%M:%S'`
account_sid="xxx" #Twilio account SID
auth_token="xxx" #Twilo auth token
twilio_number="XXXXXXXXXX"

for i in $ping_targets
do
   ping -c 1 $i > /dev/null  #ping 
   if [ $? -ne 0 ]; then #if ping gives any exit code other than 0
      if [ "$failed_hosts" == "" ]; then #if failed_hosts is empty
         failed_hosts="$i" #set failed hosts to the name of the server that failed
      else #if failed_hosts isn't empty
         failed_hosts="$failed_hosts, $i" #do something with failed_hosts
       fi #exit failed_hosts check
   fi #exit ping gives exit code other than 0
done

if [ "$failed_hosts" = "" ]; then #if we didn't have any failed hosts
        if test -f "$down_file"; then # if the anti-spam file exists
        curl "https://api.twilio.com/2010-04-01/Accounts/${account_sid}/Messages.json" -X POST --data-urlencode "To=$notify_number" --data-urlencode "From=$twilio_number" --data-urlencode "Body=Your firewall appears to be back online. Sent at $now" -u ${account_sid}:${auth_token} > /dev/null 2>&1
        rm $down_file #remove anti-spam file since we're back online
        exit 0 #close the script
        fi
fi


if [ "$failed_hosts" != "" ]; then #if failed_hosts has something in it
   if test -f "$down_file"; then 
   exit 1 #if our file to keep from spamming ourselves exists then exit
   fi #exit our check for our anti-spam file
   echo $failed_hosts| curl "https://api.twilio.com/2010-04-01/Accounts/${account_sid}/Messages.json" -X POST --data-urlencode "To=$notify_number" --data-urlencode "From=$twilio_number"  --data-urlencode "Body=Your firewall appears to be offline. Sent at $now" -u ${account_sid}:${auth_token}  > /dev/null 2>&1
   touch $down_file #create the anti-spam file
fi

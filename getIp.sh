#!/usr/bin/env bash

# Usage ./getIp.sh <resource group>

# Verify that input file was sent
if [ $# -eq 0 ]
then
  echo "No arguments supplied"
  exit 1
fi

# Obtain input parameter
resourcegroup="$1"

# Try to execute the command to check if the user is logged in (forward stderr to stdout)
TEST=$((azure network public-ip list) 2>&1)

# Log into azure if the previous command was unsucessful
if [[ ${TEST} == *"failed"* ]]
then 
  azure login
fi

#Note this is not an exhaustive test, the following command could also fail if the wrong subscription is used.

# Get IP's
azure network public-ip list $resourcegroup --json | jq '.[] | select(.ipAddress != null) | .ipAddress' > ip.txt

# Do something with each IP
while read ip; do
  # Process IP
  echo ${ip}
done <ip.txt

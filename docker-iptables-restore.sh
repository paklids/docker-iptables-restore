#!/bin/bash

infile=./iptables2
today=$(date +"%Y%m%d")
rules=$(cat /etc/iptables/filter-${today} | grep -e "^-A FORWARD " -e "^-A DOCKER " -e "^-A DOCKER-ISOLATION " )

if grep -q "^:FORWARD " $infile ; then
 mytmp=$(cat $infile)
 echo "FORWARD chain already exists"
else
 mytmp=$(sed -e '/^:INPUT.*$/a :FORWARD \[0:0\]' $infile)
fi

echo "$mytmp" | grep -q "^:DOCKER "
if [ $? -eq 0 ];then
 echo "DOCKER chain already exists"
else
 echo "DOCKER chain does not exist here so I'll add it"
 mytmp=$(echo "$mytmp" | sed -e "s/^:FORWARD.*$/& \n:DOCKER - [0:0]/")
fi

echo "$mytmp" | grep -q "^:DOCKER-ISOLATION "
if [ $? -eq 0 ];then
 echo "DOCKER-ISOLATION chain already exists"
else
 echo "DOCKER-ISOLATION chain does not exist here so I'll add it"
 mytmp=$(echo "$mytmp" | sed -e "s/^:DOCKER .*$/& \n:DOCKER-ISOLATION - [0:0]/")
fi

mytmp=$(echo "$mytmp" | sed -e 's/^COMMIT$//' )
mytmp=$(echo "$mytmp" | sed '/^\s*$/d' )
mytmp+=$'\n'"${rules}"$'\n'"COMMIT"

echo "$mytmp" > /etc/iptables/wipfilter
if grep -q "\*nat " $infile ; then
 echo "NAT table already in iptables"
 cat /etc/iptables/wipfilter > /etc/iptables/final-${today}
else
 cat /etc/iptables/nat-${today} /etc/iptables/wipfilter > /etc/iptables/final-${today}
fi


#!/bin/bash

source configuration.sh

delay=${1}; # in ms
rate=${2};  # in kilo bits per seconds

echo ${nuclouds}
for i in `seq 0 $[${nuclouds}-1]`;
  do 
    ucloud=${uclouds[$i]}
    for j in ${ucloud};
    do

	echo $j
        ${SSHCMDNODE} $j tc qdisc del dev eth0 root;
        ${SSHCMDNODE} $j tc qdisc add dev eth0 handle 1: root htb default 30
    
        # # regular traffic
        ${SSHCMDNODE} $j tc class add dev eth0 parent 1:1 classid 1:30 htb rate 1000mbit
        ${SSHCMDNODE} $j tc qdisc add dev eth0 parent 1:30 sfq

	for k in `seq 0 $[${nuclouds}-1] | sed s/$i//`;
	do
	    ucloud2=${uclouds[$k]}
            echo "node "$j" to ucloud ("${ucloud2}") traffic"
            ${SSHCMDNODE} $j tc class add dev eth0 parent 1:1 classid 1:1$k htb rate ${rate}kbit ceil ${rate}kbit
            ${SSHCMDNODE} $j tc qdisc add dev eth0 parent 1:1$k netem delay ${delay}ms
	    for l in ${ucloud2};
            do 
		echo "node "$j" to  "$l" traffic"
		${SSHCMDNODE} $j tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dst $l/32 flowid 1:1$k
            done
	done

    done

 done

#!/bin/bash

if [ $# -ne 2 ]
then
    echo "USAGE: $0 delay rate"
    exit 1
fi;

source configuration.sh

delay=${1}; # in ms
rate=${2};  # in kilo bits per seconds

ucloud0=(172.16.0.240 172.16.0.241 172.16.0.242)
ucloud1=(172.16.0.230 172.16.0.231 172.16.0.232)
ucloud2=(172.16.0.220 172.16.0.221 172.16.0.222)
nuclouds="3"
 
for i in `seq 0 $[${nuclouds}-1]`;
do 
    var=ucloud$i[@]
    echo "UCLOUD "$i    
    for node in "${!var}";     
    do         
	
	echo "NODE "${node}
        ${SSHCMDNODE} ${node} tc qdisc del dev eth0 root
        ${SSHCMDNODE} ${node} tc qdisc add dev eth0 handle 1: root htb default 30
    
        # regular traffic
        ${SSHCMDNODE} ${node} tc class add dev eth0 parent 1:1 classid 1:30 htb rate 1000mbit
        ${SSHCMDNODE} ${node} tc qdisc add dev eth0 parent 1:30 sfq

	# for j in `seq 0 $[${nuclouds}-1] | sed s/$i//`;
	# do    
        #      echo "NODE "${node}" to UCLOUD "$j
	#      var2=ucloud$j[@]
        #      ${SSHCMDNODE} ${node} tc class add dev eth0 parent 1:1 classid 1:1$j htb rate ${rate}kbit ceil ${rate}kbit
        #      ${SSHCMDNODE} ${node} tc qdisc add dev eth0 parent 1:1$j netem delay ${delay}ms
	#     for node2 in ${!var2}
        #     do 
	# 	echo "NODE "${node}" to NODE "${node2}
	# 	${SSHCMDNODE} ${node} tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dst ${node2}/32 flowid 1:1$j
        #     done
	# done
    done
 done

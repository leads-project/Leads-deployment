#!/bin/bash

source configuration.sh

function stopExp(){
    let e=${#clients[@]}-1
    for i in `seq 0 $e`
    do
        echo "stopping on ${clients[$i]}"
        ${SSHCMDNODE} root@${clients[$i]} "killall -SIGTERM java"
    done

}

trap "echo 'Caught Quit Signal'; stopExp; wait; exit 255" SIGINT SIGTERM

function listIP(){
    keyword=$1
    user=$2
    vms=`${SSHCMDHEAD} onevm list | grep ${user} | grep ${keyword} | cut -d " " -f 3`
    ips=()
    for vm in ${vms}
    do
	ip=`${SSHCMDHEAD} onevm show ${vm} | grep yes | awk '{print $5}'`
	ips+=(${ip})
    done
    echo ${ips[@]}
}

clients=(`listIP "bk-client" "psutra"`) 
bks=(`listIP "bookkeeper" "psutra"`) 
zks=("192.168.79.201") # "192.168.79.204" "192.168.79.207")
connectString="192.168.79.201" # |192.168.79.204|192.168.79.207"

entrysizes="128 256 512 1024 2048"
fadeaways="100 250 500 1000"

for entrysize in ${entrysizes}
do

    for fadeaway in ${fadeaways}
    do

	echo "Stopping bookies"
	let e=${#bks[@]}-1
	for i in `seq 0 $e`
	do
    	    ${SSHCMDNODE} root@${bks[$i]} /etc/local.d/03bookkeeper.stop &> /dev/null &
	done
	wait

	echo "Cleaning zks"
	let e=${#zks[@]}-1
	for i in `seq 0 $e`
	do
    	    ${SSHCMDNODE} root@${zks[$i]} "/opt/zookeeper/bin/zkCli.sh rmr /ledgers" &> /dev/null
    	    ${SSHCMDNODE} root@${zks[$i]} "/opt/zookeeper/bin/zkCli.sh rmr /log012" &> /dev/null
    	    ${SSHCMDNODE} root@${zks[i]} "/opt/zookeeper/bin/zkCli.sh rmr /coord" &> /dev/null
	done
	wait

	sleep 30

	echo "Starting bookies"
	let e=${#bks[@]}-1
	for i in `seq 0 $e`
	do
    	    ${SSHCMDNODE} root@${bks[$i]} /etc/local.d/03bookkeeper.start &> /dev/null &
    	    sleep 1
	done
	wait

    	CMD="/opt/bookkeeper/benchmark writes -quorum 2 -ensemble 3 -zookeeper \"${connectString}\" -skipwarmup  -entrysize ${entrysize} -time 45 -fadeaway ${fadeaway} -throttle 100000 -coordnode /coord | grep ops"

    	echo "LAUNCHING WITH ${entrysize} ${fadeaway}"

    	echo "Launching."
    	rm -f output*
    	let e=${#clients[@]}-1
    	for i in `seq 0 $e`
    	do
    	    ${SSHCMDNODE} root@${clients[$i]} ${CMD} &> output_${clients[$i]} &
    	done

    	sleep 10

    	echo "Creating coord node"
    	for i in `seq 0 $e`
    	do
    	    ${SSHCMDNODE} root@${zks[i]} "/opt/zookeeper/bin/zkCli.sh create /coord \"\"" &> /dev/null
    	done
    	wait 

    	echo "Computing throughput"
    	throughput=0
    	let e=${#clients[@]}-1
    	for i in `seq 0 $e`
    	do
    	    tmp=`grep "ops" output_${clients[$i]} | cut -d" " -f 14`
    	    throughput=`echo "${tmp}+${throughput}"`
    	done
    	overall_throughput=`echo "${throughput}" | ${bc}`;
    	echo ${overall_throughput}
    	echo ${overall_throughput} ${entrysize} ${fadeaway} >> result
	
    done

done


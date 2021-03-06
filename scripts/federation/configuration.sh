#!/bin/bash

source ../gconfiguration.sh

# We partition the nodes in ${nuclouds} uclouds.
# All the resulting uclouds are stored in $uclouds, e.g., ${uclouds[0]} contains the first ucloud.
# The parameters below are also used by deploy-netem.sh and undeploy-netem.sh

${SSHCMDHEAD} ONE_AUTH=${ONE_AUTH_FILE} "onevm list | grep ${USER} | grep ispn | gawk '{print \"ONE_AUTH=${ONE_AUTH_FILE} onevm show  \" \$1}'| sh | grep vnet | gawk '{result=\$5; while(getline){result=result\" \"\$5} print result}'" > /tmp/nodes
nod=`cat /tmp/nodes`
IFS=' ' read -a nodes <<<  "${nod}"
nnodes=${#nodes[@]}
client="192.168.79.117"

nuclouds="3"
let nodesPerUcloud=$nnodes/$nuclouds
if [[ $nodesPerUcloud*$nuclouds -ne $nnodes ]]
then
    echo "invalid number of uclouds"
    exit -1
fi

echo "Emulating "${nuclouds}" UCloud(s) of "${nodesPerUcloud}" Node(s)."
for g in `seq 1 ${nuclouds}`
do
    let begin=($g-1)*${nodesPerUcloud}
    let end=$g*${nodesPerUcloud}-1
    for i in `seq ${begin} ${end}`
    do
	if [[ $i -eq ${begin} ]]
	then
	    ucloud=(${nodes[$i]})
	else
	    ucloud=("`echo $ucloud` ${nodes[$i]}")
	fi
    done
    if [[ g -eq 1 ]]
    then 
	echo "adding client"
	ucloud=("`echo $ucloud` ${client}")
    fi
    uclouds[$g-1]=$ucloud
    echo "UCloud "${g}" = ("${ucloud[@]}")"
done

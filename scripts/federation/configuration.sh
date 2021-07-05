#!/bin/bash

source ../gconfiguration.sh

# We partition the nodes in ${nuclouds} uclouds.
# All the resulting uclouds are stored in $uclouds, e.g., ${uclouds[0]} contains the first ucloud.
# The parameters below are also used by deploy-netem.sh and undeploy-netem.sh

# ${SSHCMDHEAD} ONE_AUTH=${ONE_AUTH_FILE} "onevm list | grep ${USER} | grep leads | gawk '{print \"ONE_AUTH=${ONE_AUTH_FILE} onevm show  \" \$1}'| sh | grep ETH0_IP | sed -r 's/[^\"]*[\"]([^\"]*)[\"][,]?[^\"]*/\1/g'" > /tmp/nodes

IFS=$'\r\n' 
GLOBIGNORE='*'
nodes=($(cat /tmp/nodes))
nnodes=${#nodes[@]}

nuclouds="3"
# let nodesPerUcloud=$nnodes/$nuclouds
# if [[ $nodesPerUcloud*$nuclouds -ne $nnodes ]]
# then
#     echo "invalid number of uclouds"
#     exit -1
# fi

# echo "Emulating "${nuclouds}" UCloud(s) of "${nodesPerUcloud}" Node(s)."
# uclouds=()
# for g in `seq 1 ${nuclouds}`
# do
#     let begin=($g-1)*${nodesPerUcloud}
#     let end=$g*${nodesPerUcloud}
#     ucloud=()
#     for i in `seq ${begin} ${end}`
#     do
# 	ucloud+=("${nodes[$i]}")
#     done
#     uclouds+=($ucloud)
#     #echo "UCloud "$[$g-1]" = ("${ucloud[@]}")"
# done


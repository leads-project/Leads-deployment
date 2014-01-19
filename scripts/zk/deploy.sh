#!/bin/bash

source configuration.sh

NAME="zk"
IPS="192.168.79.201 192.168.79.202 192.168.79.203"

# for each IP
# correct template 
# then instanciate vm with the appropriate name
for IP in ${IPS}
do
    echo "Instanciating ${IP}"
    sed s/\@ZK_PEERS\@/"${IPS}"/ ${ZK_TMPL_FILE} | sed s/\@IP\@/"${IP}"/ > tmp
    scp tmp ${USER}@${CLUSTER}:~/
    ${SSHCMDHEAD}  ONE_AUTH=${ONE_AUTH_FILE} onetemplate update ${ZK_TMPL_ID} tmp
    ${SSHCMDHEAD} ONE_AUTH=${ONE_AUTH_FILE} onetemplate instantiate ${ZK_TMPL_ID} --name ${NAME}
done
rm -f tmp

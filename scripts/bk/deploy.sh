#!/bin/bash

source configuration.sh

NAME="bookkeeper"
NBOOKIES="18"
ZK_PEERS="192.168.79.228,192.168.79.229,192.168.79.230|192.168.79.231,192.168.79.232,192.168.79.233|192.168.79.234,192.168.79.235,192.168.79.236"

# for each bookie
# correct template 
# then instanciate vm with the appropriate name
for i in `seq 1 ${NBOOKIES}`
do
    echo "Instanciating bookie ${i}"
    sed s/\@ZK_PEERS\@/"${ZK_PEERS}"/ ${BK_TMPL_FILE}> tmp
    scp tmp ${USER}@${CLUSTER}:~/
    ${SSHCMDHEAD}  ONE_AUTH=${ONE_AUTH_FILE} onetemplate update ${BK_TMPL_ID} tmp
    ${SSHCMDHEAD} ONE_AUTH=${ONE_AUTH_FILE} onetemplate instantiate ${BK_TMPL_ID} --name ${NAME}
done
rm -f tmp

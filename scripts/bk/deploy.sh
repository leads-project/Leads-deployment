#!/bin/bash

source configuration.sh

NAME="bk"
NBOOKIES="3"
ZK_PEERS="192.168.79.201,192.168.79.202,192.168.79.203"

# for each bookie
# correct template 
# then instanciate vm with the appropriate name
for i in `seq 1 ${NBOOKIES}`for i in `seq 1 ${NBOOKIES}`
do
    echo "Instanciating bookie ${i}"
    sed s/\@ZK_PEERS\@/"${ZK_PEERS}"/ ${BK_TMPL_FILE}> tmp
    scp tmp ${USER}@${CLUSTER}:~/
    ${SSHCMDHEAD}  ONE_AUTH=${ONE_AUTH_FILE} onetemplate update ${BK_TMPL_ID} tmp
    ${SSHCMDHEAD} ONE_AUTH=${ONE_AUTH_FILE} onetemplate instantiate ${BK_TMPL_ID} --name ${NAME}
done
rm -f tmp

#!/bin/bash

source configuration.sh

NAME="bk-client"
NCLIENTS="20"

scp ${TMPL_FILE} ${USER}@${CLUSTER}:~/tmp
${SSHCMDHEAD} onetemplate update ${TMPL_ID} tmp

for i in `seq 1 ${NCLIENTS}`
do
    echo "Instanciating client ${i}"
    ${SSHCMDHEAD} onetemplate instantiate ${TMPL_ID} --name ${NAME}
done
rm -f tmp

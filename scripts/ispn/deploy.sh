#!/bin/bash

source configuration.sh

NAME="ispn1"
NISPN="3"
BPING_PORT="26001"

# for each IP
# correct template 
# then instanciate vm with the appropriate name
for i in `seq 1 ${NISPN}`
do
    echo "Instanciating infinispan #${i} (${NAME})"
    sed s/\@BPING_PORT\@/"${BPING_PORT}"/ ${ISPN_TMPL_FILE} > tmp
    scp tmp ${USER}@${CLUSTER}:~/
    ${SSHCMDHEAD} onetemplate update ${ISPN_TMPL_ID} tmp
    ${SSHCMDHEAD} onetemplate instantiate ${ISPN_TMPL_ID} --name ${NAME}
done
rm -f tmp

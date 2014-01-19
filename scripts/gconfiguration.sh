#!/bin/bash

USER="USER"
PASSWORD="PASS"
CLUSTER="clusterinfo.unineuchatel.ch"

SSHCMDHEAD="ssh -l ${USER} ${CLUSTER}"
SSHCMDNODE="ssh -l root -i id_rsa"
ID_DATASTORE="100"
ID_TEMPLATE="237"
ONE_AUTH_FILE="/home/psutra/one_auth"


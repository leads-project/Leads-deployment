#!/bin/bash

HOME_DIR="/home/otrack/Implementation/Leads-deployment"
SCRIPTS_DIR="/home/otrack/Implementation/Leads-deployment/scripts"

USER="psutra"
PASSWORD=""
CLUSTER="clusterinfo.unineuchatel.ch"
ID_DATASTORE="100"
ONE_AUTH_FILE="/home/psutra/one_auth"

SSHCMDHEAD="ssh -l ${USER} ${CLUSTER} ONE_AUTH=${ONE_AUTH_FILE}"
SSHCMDNODE="ssh"



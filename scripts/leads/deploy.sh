#!/bin/bash

source configuration.sh

NAME="leads2"
LEADS_NODES="172.16.0.230 172.16.0.231 172.16.0.232"
BPING_PORT="26002"

set ${LEADS_NODES}

HDFS_NAMENODE=$1
MAPRED_TRACKER=${HDFS_NAMENODE}
shift;
for n in "$@" ; do
    HADOOP_SLAVES="${n} ${HADOOP_SLAVES}"
done

# for each IP
# correct template 
# then instanciate vm with the appropriate name
for s in ${LEADS_NODES}
do
    echo "Instanciating leads node (${s})"
    HOSTNAME="node-$(echo ${s} | sed s/\\./\-/g)"
    sed s/\@NODE_IP\@/"$s"/g ${LEADS_TMPL_FILE} | \
	sed s/\@HOSTNAME\@/"${HOSTNAME}"/g | \
	sed s/\@HDFS_NAMENODE\@/"${HDFS_NAMENODE}"/g | \
	sed s/\@MAPRED_TRACKER\@/"${MAPRED_TRACKER}"/g  | \
	sed s/\@HADOOP_SLAVES\@/"${HADOOP_SLAVES}"/g | \
	sed s/\@BPING_PORT\@/"${BPING_PORT}"/ > t
    scp -q t ${USER}@${CLUSTER}:~/
    ${SSHCMDHEAD} onetemplate update ${LEADS_TMPL_ID} t
    ${SSHCMDHEAD} onetemplate instantiate ${LEADS_TMPL_ID} --name ${NAME}
done
rm -f t

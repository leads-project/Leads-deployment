#!/bin/bash

source configuration.sh

NAME="stacksync"
LEADS_NODES="172.16.0.179 172.16.0.180" #172.16.0.222 172.16.0.223 172.16.0.224 172.16.0.225 172.16.0.226 172.16.0.227 172.16.0.228 172.16.0.229"
BPING_PORT="24516"

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

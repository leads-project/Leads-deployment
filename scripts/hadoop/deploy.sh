#!/bin/bash

source configuration.sh

NAME="hadoop1"
HADOOP_NODES="172.16.0.201 172.16.0.202 172.16.0.203 172.16.0.204"

set ${HADOOP_NODES}
HDFS_NAMENODE=$1
MAPRED_TRACKER=${HDFS_NAMENODE}
shift;
for n in "$@" ; do
    HADOOP_SLAVES="${n} ${HADOOP_SLAVES}"
done

# for each IP
# correct template 
# then instanciate vm with the appropriate name
for s in ${HADOOP_NODES}
do
    echo "Instanciating hadoop (${s}, ${NAME})"
    sed s/\@NODE_IP\@/"$s"/g ${HADOOP_TMPL_FILE} | \
	sed s/\@HDFS_NAMENODE\@/"${HDFS_NAMENODE}"/g | \
	sed s/\@MAPRED_TRACKER\@/"${MAPRED_TRACKER}"/g  | \
	sed s/\@HADOOP_SLAVES\@/"${HADOOP_SLAVES}"/g > tmp
    scp tmp ${USER}@${CLUSTER}:~/
    ${SSHCMDHEAD} onetemplate update ${HADOOP_TMPL_ID} tmp
    ${SSHCMDHEAD} onetemplate instantiate ${HADOOP_TMPL_ID} --name ${NAME}
done
rm -f tmp

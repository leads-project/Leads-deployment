#!/bin/bash

source config.sh

build_infinispan(){

    echo "here"
    exit 0

    if [ ! -d ${DIR_ROOT}/build/infinispan ]
    then
	echo "No Infinispan directory; aborting."
	exit -1
    fi;

    ln -s opt-infinispan.img ${DIR_IMG}/opt.img
    . ${DIR_ROOT}/imgmnt.sh mount 
    sudo rm -Rf ${MOUNT_ROOT}/build/infinispan/infinispan
    # sudo cp -Rf ${DIR_ROOT}/opt/infinispan/infinispan ${MOUNT_ROOT}/opt/
}

eval build_$1

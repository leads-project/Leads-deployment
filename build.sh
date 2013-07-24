#!/bin/bash

source config.sh
DIR_ETC=${DIR_ROOT}/build/etc
DIR_LOCAL_D=${DIR_ROOT}/build/etc/local.d
DIR_INFINISPAN=${DIR_ROOT}/build/infinispan
DIR_CLIENT=${DIR_ROOT}/build/client

if [ -d ${MOUNT_OPT} ]
then
    echo "Image already mounted; aborting"
    exit -1
fi;

build_core(){
    echo "Building Core image."
    echo "Mounting."
    . ${DIR_ROOT}/imgmnt.sh mount 
    echo "Copying files."
    sudo cp ${DIR_ETC}/* ${MOUNT_ROOT}/etc/ 2&> /dev/null
    sudo cp ${DIR_LOCAL_D}/* ${MOUNT_ROOT}/etc/local.d/
    echo "Unmounting ..."
    . ${DIR_ROOT}/imgmnt.sh umount 
    echo "Done."
}    

build_infinispan(){
    echo "Building Infinispan image."
    if [[ ! -e ${DIR_INFINISPAN}/infinispan.zip ]]
    then
	echo "No Infinispan archive in ${DIR_INFINISPAN}; aborting."
	exit -1
    fi;
    ln --force -s opt-infinispan.img ${DIR_IMG}/opt.img

    echo "Mounting."
    . ${DIR_ROOT}/imgmnt.sh mount 
    sudo rm -Rf ${MOUNT_OPT}/infinispan

    echo -n "Uncompresisng Infinispan archive ... "
    sudo unzip -o ${DIR_INFINISPAN}/infinispan.zip -d ${MOUNT_OPT} > /dev/null
    echo "done"    
    echo "Configuring Infinispan."
    sudo mv ${MOUNT_OPT}/*infinispan* ${MOUNT_OPT}/infinispan
    sudo cp -f ${DIR_INFINISPAN}/infinispan-config.xml.tmpl ${MOUNT_OPT}/infinispan/standalone/configuration

    echo "Unmounting ..."
    . ${DIR_ROOT}/imgmnt.sh umount 
    echo "Done."
}

build_client(){
    echo "Building Client image."
    if [[ ! -e ${DIR_CLIENT}/crawler/crawler.jar ]]
    then
	echo "No Crawler archive in ${DIR_CLIENT}/crawler; aborting."
	exit -1
    fi;
    ln --force -s opt-client.img ${DIR_IMG}/opt.img

    echo "Mounting."
    . ${DIR_ROOT}/imgmnt.sh mount 

    echo -n "Adding Crawler files ... "
    if [[ ! -d ${MOUNT_OPT}/crawler ]]
    then
	sudo mkdir ${MOUNT_OPT}/crawler
    fi;
    sudo cp -f ${DIR_CLIENT}/crawler/* ${MOUNT_OPT}/crawler
    sudo chmod +x ${MOUNT_OPT}/crawler/pcrawl.sh
    sudo chmod +x ${MOUNT_OPT}/crawler/icrawl.sh
    echo "done"    

    echo "Unmounting ..."
    . ${DIR_ROOT}/imgmnt.sh umount 
    echo "Done."
}

eval build_$1

#!/bin/bash

source config.sh

mount(){
    sudo mount -o loop,rw,exec,offset=32256 ${IMG_GENTOO} ${MOUNT_ROOT}
    sudo mount -t proc -o dev,rw,exec /proc/ ${MOUNT_PROC}
    sudo mount -o loop,rw,exec,offset=512 ${IMG_OPT} ${MOUNT_OPT}

    sudo mount -rt squashfs -o loop,nodev,noexec ${IMG_SQFS_KERNEL_SRC} ${MOUNT_KERNEL_SRC_RO}
    sudo unionfs-fuse -o cow,allow_other,use_ino,suid,dev,nonempty  ${MOUNT_KERNEL_SRC_RW}=RW:${MOUNT_KERNEL_SRC_RO}=RO ${MOUNT_KERNEL_SRC}

    sudo mount -rt squashfs -o loop,nodev,noexec ${IMG_SQFS_PORTAGE} ${MOUNT_PORTAGE_RO}
    sudo unionfs-fuse -o cow,allow_other,use_ino,suid,dev,nonempty ${MOUNT_PORTAGE_RW}=RW:${MOUNT_PORTAGE_RO}=RO ${MOUNT_PORTAGE}
    wait
}

umount(){

    sudo sync
    wait

    if [ ! -z `ls -A ${MOUNT_PORTAGE_RW} | head -n1` ]
    then
    	echo "Updating portage.img ... "
    	rm -f ${IMG_SQFS_PORTAGE}.tmp
    	mksquashfs ${MOUNT_PORTAGE} ${IMG_SQFS_PORTAGE}.tmp -no-duplicates 2>/dev/null
    	mv ${IMG_SQFS_PORTAGE}.tmp ${IMG_SQFS_PORTAGE}
    fi
    sudo rm -Rf ${MOUNT_PORTAGE_RW}
    sudo umount ${MOUNT_PORTAGE}
    sudo umount ${MOUNT_PORTAGE_RO}

    if [ ! -z `ls -A ${MOUNT_KERNEL_SRC_RW} | head -n1` ]
    then
    	echo "Updating kernel-src.img ... "
    	rm -f ${IMG_SQFS_KERNEL_SRC}.tmp
    	mksquashfs ${MOUNT_KERNEL_SRC} ${IMG_SQFS_KERNEL_SRC}.tmp -no-duplicates 2>/dev/null
    	mv ${IMG_SQFS_KERNEL_SRC}.tmp ${IMG_SQFS_KERNEL_SRC}
    fi
    sudo rm -Rf ${MOUNT_KERNEL_SRC_RW}
    sudo umount ${MOUNT_KERNEL_SRC}
    sudo umount ${MOUNT_KERNEL_SRC_RO}

    sudo umount ${MOUNT_OPT}
    sudo umount ${MOUNT_PROC}
    sudo umount ${MOUNT_ROOT}
}

eval $1

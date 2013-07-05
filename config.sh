#!/bin/bash

DIR_ROOT="/home/otrack/ALL/myWork/Implementation/OpenNebula"
DIR_IMG="${DIR_ROOT}/images"

### Images
IMG_GENTOO="${DIR_IMG}/gentoo.img"
IMG_OPT="${DIR_IMG}/opt.img"
IMG_SQFS_PORTAGE="${DIR_IMG}/portage.img"
IMG_SQFS_KERNEL_SRC="${DIR_IMG}/kernel-src.img"

### Mounting directories
MOUNT_ROOT="/mnt/img"
MOUNT_PROC="${MOUNT_ROOT}/proc"
MOUNT_OPT="${MOUNT_ROOT}/misc/opt"
MOUNT_KERNEL_SRC="${MOUNT_ROOT}/usr/src/linux-3.5.7-gentoo"
MOUNT_PORTAGE="${MOUNT_ROOT}/usr/portage"

### Mount initialization 

# portage
MOUNT_PORTAGE_RW="/dev/shm/portage-rw" 
[ -d ${MOUNT_PORTAGE_RW} ] || mkdir -p ${MOUNT_PORTAGE_RW}
MOUNT_PORTAGE_RO="/dev/shm/portage-ro" 
[ -d ${MOUNT_PORTAGE_RO} ] || mkdir -p ${MOUNT_PORTAGE_RO}

# kernel
MOUNT_KERNEL_SRC_RW="/dev/shm/kernel-rw" 
[ -d ${MOUNT_KERNEL_SRC_RW} ] || mkdir -p ${MOUNT_KERNEL_SRC_RW}
MOUNT_KERNEL_SRC_RO="/dev/shm/kernel-ro" 
[ -d ${MOUNT_KERNEL_SRC_RO} ] || mkdir -p ${MOUNT_KERNEL_SRC_RO}

#!/bin/bash

source ../config.sh

qemu-img create -f qcow2 -b ${IMG_GENTOO} gentoo.qcow2
qemu-img create -f qcow2 -b ${IMG_OPT} opt.qcow2
mkisofs -o blank.iso context.sh
qemu-system-i386 gentoo.qcow2 -hdb opt.qcow2 -net nic,model=rtl8139,macaddr=02:00:c0:a8:4f:41 -cdrom blank.iso
# -net tap,ifname=tap0

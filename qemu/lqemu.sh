#!/bin/bash

source ../config.sh

qemu-img create -f qcow2 -b ${IMG_GENTOO} gentoo.qcow2
qemu-img create -f qcow2 -b ${IMG_OPT} opt.qcow2
rm -f blank.iso
mkisofs -o blank.iso context.sh
qemu-system-i386 gentoo.qcow2 -hdb opt.qcow2\
    -m 1500M \
    -cpu qemu64,+ssse3,+sse4.1,+sse4.2,+x2apic \
    -smp 4 \
    -cdrom blank.iso \
    -net nic,model=virtio,macaddr=02:00:c0:a8:4f:41 \
    -net user,hostfwd=tcp:127.0.0.1:11222-:11222
    

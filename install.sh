#!/bin/sh

SSHCMD="sshcluster"
ID_DATASTORE="100"

# 1 - install the images
install_images(){
    ${SSHCMD} oneimage create -d ${ID_DATASTORE} -name gentoo --driver raw --prefix hd gentoo.img
}

# 2 - install the templates
install_templates(){

}

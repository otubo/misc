#!/bin/sh

GUESTNAME=$1;
CDROM=$2;

#--disk /dados/virt/${GUESTNAME}/${GUESTNAME}-disk.img,size=5,format=raw \
#--disk /dados/virt/${GUESTNAME}/${GUESTNAME}-disk.img \
#--os-variant fedora17 \
mkdir ${GUESTNAME};
chown otubo:otubo ${GUESTNAME} -R;

virt-install --connect qemu:///system \
             --name=${GUESTNAME} \
             --ram=1024 \
             --vcpus=1 \
             --os-type linux \
             --cdrom ${CDROM} \
             --os-type=linux \
             --disk /home/otubo/paodealho.img \
             --network bridge=virbr0 \
             --accelerate \
             --vnc

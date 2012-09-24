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
             --arch=i386 \
             --os-type linux \
             --cdrom ${CDROM} \
             --os-type=linux \
             --disk ${GUESTNAME}/${GUESTNAME}-disk.img,size=8,format=raw \
             --network bridge=virbr0 \
             --accelerate \
             --vnc

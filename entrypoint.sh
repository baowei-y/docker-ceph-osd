#!/bin/bash
set -e

: ${CLUSTER:=ceph}
: ${HOSTNAME:=$(hostname -s)}
: ${WEIGHT:=1.0}
#######
# OSD #
#######

OSD_ID=$(ls /var/lib/ceph/osd|awk -F- '{print $2 }')
OSD_PATH=/var/lib/ceph/osd/${CLUSTER}-${OSD_ID}

if [ ! -e ${OSD_PATH}/keyring ]; then
  # bootstrap OSD
  mkdir -p ${OSD_PATH}
  ceph osd create
  ceph-osd -i ${OSD_ID} --mkfs
  ceph auth get-or-create osd.${OSD_ID} osd 'allow *' mon 'allow profile osd' -o ${OSD_PATH}/keyring
  ceph osd crush add ${OSD_ID} ${WEIGHT} root=default host=${HOSTNAME}
  ceph-osd -i ${OSD_ID} -k ${OSD_PATH}/keyring
  ceph -w
fi

# start OSD
ceph-osd -i ${OSD_ID} -k ${OSD_PATH}/keyring
ceph -w

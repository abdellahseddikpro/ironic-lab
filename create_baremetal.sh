#!/bin/bash

# Usage
# ./create_baremetal.sh  <Node name > <Disk size> <VCPU> <RAM>
#Example:
# ./create_baremetal.sh  01 10G 1 4096

# Create Empty disk
mkdir -p  /home/vagrant/nodes/node_$1/
qemu-img create  -f qcow2 /home/vagrant/nodes/node_$1/nodes_$1.img

# Create the controller VM
virt-install -n node_$1 -r $4 --vcpus $3 \
  --os-type linux  \
  --disk /home/vagrant/nodes/node_$1/nodes_$1.img,bus=virtio,format=qcow2 \
  --network bridge=br-baremetal,model=virtio \
  --vnc --import --print-xml > /tmp/node_$1.xml

virsh define /tmp/node_$1.xml
virsh autostart node_$1
rm /tmp/node_$1.xml
virsh start node_$1

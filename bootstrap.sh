#!/bin/bash

echo "-------BOOTSTRAP-------"
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/^#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
echo 'vagrant:vagrant' | sudo chpasswd
echo '192.168.143.100 openstack.example.org' | sudo tee -a /etc/hosts
echo '192.168.143.50  controller openstack.example.org' | sudo tee -a /etc/hosts
echo '192.168.143.80  storage' | sudo tee -a /etc/hosts
echo '192.168.143.60  compute' | sudo tee -a /etc/hosts
echo '192.168.143.70  baremetal' | sudo tee -a /etc/hosts
echo "-------END BOOTSTRAP-------"

FILE=/home/vagrant/openstack_scripts.tar.gz
if [ -f "$FILE" ]; then
   tar -xf /home/vagrant/openstack_scripts.tar.gz --directory  /home/vagrant/
   rm /home/vagrant/openstack_scripts.tar.gz
fi

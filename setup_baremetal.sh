# Install Libvirt
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install virt-manager qemu-kvm qemu-system libvirt-bin \
    lvm2 vim cpu-checker libvirt-dev python-libvirt python3-libvirt -y
# Install VirtualBMC
sudo apt install  -y  python-pip 
sudo pip install virtualbmc==1.6.0 
sudo pip install configparser
sudo apt-get install -y ipmitool
sudo usermod -a -G libvirt vagrant
# Setup Networking
apt install bridge-utils
brctl addbr br-baremetal
brctl addif br-baremetal eth4 
sudo ifconfig  eth4 up
sudo ifconfig  br-baremetal  up
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-local.conf
sudo sysctl -p /etc/sysctl.d/99-local.conf
# Setup permissions
#chmod +x /home/vagrant/create_baremetal.sh

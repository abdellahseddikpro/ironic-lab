# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  boxes = [
    { :name => "controller01", :ip => "192.168.142.50", :mgmt => "192.168.143.50", :fip => "192.168.144.50", :baremetal => "192.168.145.50", :cpu => 2, :mem => 4096},
    { :name => "storage01", :ip => "192.168.142.80", :mgmt => "192.168.143.80", :fip => "192.168.144.80", :baremetal => "192.168.145.80", :cpu => 1, :mem => 1024 },
    { :name => "compute01", :ip => "192.168.142.60", :mgmt => "192.168.143.60", :fip => "192.168.144.60", :baremetal => "192.168.145.60", :cpu => 2, :mem => 2048 },
    { :name => "baremetal01", :ip => "192.168.142.70", :mgmt => "192.168.143.70", :fip => "192.168.144.70", :baremetal => "192.168.145.70", :cpu => 2, :mem => 4096 },
  ]
  config.vm.box = "generic/ubuntu1804"
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.disksize.size = '100GB'
  boxes.each do |box|
    config.vm.define box[:name] do |host|
      host.vm.hostname = box[:name]
      # Internet
      host.vm.network "private_network", libvirt__network_name: "public", ip: box[:ip]
      # Internal 
      host.vm.network "private_network", libvirt__network_name: "mgmt", ip: box[:mgmt]
      # FIP
      host.vm.network "private_network", libvirt__network_name: "fip", ip: box[:fip], auto_config: false
      # Baremetal
      host.vm.network "private_network", libvirt__network_name: "baremetal", ip: box[:baremetal], auto_config: false
      host.vm.provider "virtualbox" do |vm|
        vm.cpus = box[:cpu]
        vm.memory = box[:mem]
        vm.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
        vm.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
        vm.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
        vm.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
        vm.customize ["modifyvm", :id, "--nicpromisc5", "allow-all"]
        if box[:name] =~ /#{'storage'}/ 
          file_to_disk = "cinder.vdi"
          vm.customize ["storagectl", :id, "--name", "SATA Controller", "--add", "sata", "--controller", "IntelAHCI"]
          unless File.exist?(file_to_disk)
            vm.customize ["createhd", "--filename", file_to_disk, "--size", 10 * 1024, "--format", "VDI"]
          end
          vm.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 0, "--device", 0, "--type", "hdd", "--medium", file_to_disk]
        end
      end
      config.vm.provision "file", source: "openstack_scripts.tar.gz", destination: "/home/vagrant/openstack_scripts.tar.gz"
      host.vm.provision "shell", path: "bootstrap.sh"
      if box[:name] =~ /#{'baremetal'}/ 
        host.vm.provision "shell", path: "setup_baremetal.sh"
      end
    end
  end
end

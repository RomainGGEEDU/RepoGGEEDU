# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.network "forwarded_port", guest: 80, host: 1234

  config.vm.synced_folder "./", "/src"

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.name = "vmProject"
    vb.memory = "2048"
  end
  
  config.vm.provision "shell", path: "vagrant/bootstrap.sh"
end

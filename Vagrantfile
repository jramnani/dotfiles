# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provision "shell",
                      inline: "sudo -u vagrant -H /vagrant/install.sh -p"

  # Don't need a beefy virtual machine to test whether my profile works.
  config.vm.provider "virtualbox" do |v|
    v.memory = 256
    v.cpus = 1
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "trusty"
  end

  config.vm.define "centos" do |centos|
    centos.vm.box = "chef/centos-6.5"
  end

  config.vm.define "freebsd" do |bsd|
    bsd.vm.box = "chef/freebsd-10.0"
    bsd.vm.network "private_network", type: "dhcp"
    bsd.vm.synced_folder ".", "/vagrant", type: "nfs"
  end

  # Virtualbox not reporting guest IP on private network when using DHCP.
  config.vm.define "openbsd" do |bsd|
    version = "5.6"
    bsd.vm.box = "tmatilai/openbsd-#{version}"
    bsd.vm.network "private_network", ip: "192.168.33.10"
    bsd.vm.synced_folder ".", "/vagrant", type: "rsync"
    bsd.ssh.shell = "/bin/ksh"
    bsd.vm.provision "shell",
                     inline: "PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/#{version}/packages/amd64/ sudo pkg_add -I bash"
  end

end

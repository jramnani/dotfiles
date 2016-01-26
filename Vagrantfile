# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provision "shell",
                      inline: "/vagrant/install.sh -p",
                      privileged: false

  # Don't need a beefy virtual machine to test whether my profile works.
  config.vm.provider "virtualbox" do |v|
    v.memory = 256
    v.cpus = 1
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu/trusty64"
  end

  config.vm.define "centos" do |centos|
    centos.vm.box = "chef/centos-6.5"
  end

  config.vm.define "freebsd" do |bsd|
    bsd.vm.box = "freebsd/FreeBSD-10.2-RELEASE"
    bsd.vm.network "private_network", ip: "192.168.32.10"
    bsd.vm.base_mac = "080027D14C66"
    bsd.vm.synced_folder ".", "/vagrant", type: "nfs"
    bsd.ssh.shell = "sh"
    bsd.vm.provision "shell",
                     inline: "pkg install -y bash fish"

    bsd.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    end
  end

  # Virtualbox not reporting guest IP on private network when using DHCP.
  config.vm.define "openbsd" do |bsd|
    openbsd_mirror = "ftp://ftp.vim.org/mirror/OpenBSD/"
    version = "5.7"
    arch = "amd64"

    bsd.vm.box = "tmatilai/openbsd-#{version}"
    bsd.vm.network "private_network", ip: "192.168.33.10"
    bsd.vm.synced_folder ".", "/vagrant", type: "rsync"
    bsd.ssh.shell = "/bin/ksh"
    bsd.vm.provision "shell",
                     inline: "PKG_PATH=#{openbsd_mirror}/#{version}/packages/#{arch}/ sudo pkg_add -I bash"
  end
end

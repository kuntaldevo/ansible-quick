# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 config.hostmanager.enabled = true
 config.hostmanager.manage_host = true
 config.hostmanager.manage_guest = true
 config.hostmanager.ignore_private_ip = false
 config.hostmanager.include_offline = true
 config.ssh.insert_key = false


  # MongoDB
  #config.vm.define "mongo" do |mongo|
   # mongo.vm.hostname = "mongo"
   # mongo.vm.box = "geerlingguy/centos7"
   # mongo.vm.network :private_network, ip: "192.168.60.3"
  #end

  # Paxata Core Server
  config.vm.define "paxcore" do |paxcore|
    paxcore.vm.hostname = "paxcore"
    paxcore.vm.box = "geerlingguy/centos7"
    paxcore.vm.network :private_network, ip: "192.168.60.4"
    config.vm.provider :virtualbox do |v|
      v.memory = 6144
      v.cpus = 2
    end
  end
  
  # Paxata Core Server
  config.vm.define "paxdata" do |paxdata|
    paxdata.vm.hostname = "paxdata"
    paxdata.vm.box = "geerlingguy/centos7"
    paxdata.vm.network :private_network, ip: "192.168.60.6"
  end

   # Paxata Core Server
    config.vm.define "paxauto" do |paxauto|
      paxauto.vm.hostname = "paxauto"
      paxauto.vm.box = "geerlingguy/centos7"
      paxauto.vm.network :private_network, ip: "192.168.60.7"
    end


  # Paxata Pipeline / Spark Master.
  config.vm.define "pipelinemaster" do |pm|
    pm.vm.hostname = "pm"
    pm.vm.box = "geerlingguy/centos7"
    pm.vm.network :private_network, ip: "192.168.60.5"
    config.vm.provider :virtualbox do |v|
      v.memory = 2048
      v.cpus = 1
    end
  end
  
  # Spark Worker 1 to 2.
  (1..3).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.hostname = "worker#{i}"
      worker.vm.box = "geerlingguy/centos7"
      worker.vm.network :private_network, ip: "192.168.60.10#{i}"
      config.vm.provider :virtualbox do |v|
        v.memory = 3072
        v.cpus = 1
      end
    end
  end
end

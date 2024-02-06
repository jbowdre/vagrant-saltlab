# -*- mode: ruby -*-
# vi: set ft=ruby :

# Salt lab environment with one master and various minions

# hardware specs
CPU_COUNT = 2
MEMORY_MB = 1024

Vagrant.configure("2") do |config|
  config.nfs.verify_installed = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.define "salt", primary: true do |salt|
    salt.vm.box = "bento/ubuntu-22.04"
    salt.vm.hostname = "salt"
    salt.vm.network :private_network,
      :ip => "192.168.100.120",
      :libvirt__dhcp_enabled => false
    salt.vm.provider :libvirt do |libvirt|
      libvirt.cpus = CPU_COUNT
      libvirt.memory = MEMORY_MB
    end
    salt.vm.synced_folder 'salt_content/local', '/srv', type: 'rsync'
    salt.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install curl vim -y
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -M -X -U stable 3006
      salt-pip install pygit2
      cat << EOF > /etc/salt/master.d/lab.conf
auto_accept: True
file_roots:
  base:
    - /srv/salt
  acg:
    - /srv/salt/acg
fileserver_backend:
  - roots
  - gitfs
gitfs_provider: pygit2
gitfs_update_interval: 60
gitfs_base: main
gitfs_remotes:
  - https://github.com/jbowdre/vagrant-saltlab.git:
    - root: salt_content/gitfs/salt
    - mountpoint: salt://
pillar_roots:
    base:
      - /srv/pillar
ext_pillar:
  - git:
    - main https://github.com/jbowdre/vagrant-saltlab.git:
      - root: salt_content/gitfs/pillar
      - env: base
reactor:
  - 'salt/minion/*/start':
    - salt://_reactor/sync_grains.sls
EOF
      systemctl start salt-master
      systemctl start salt-minion
      sleep 5
      systemctl restart salt-master
    SHELL
  end
  config.vm.define "minion01" do |minion01|
    minion01.vm.box = "bento/ubuntu-22.04"
    minion01.vm.hostname = "minion01"
    minion01.vm.network :private_network,
      :ip => "192.168.100.121",
      :libvirt__dhcp_enabled => false
    minion01.vm.provider :libvirt do |libvirt|
      libvirt.cpus = CPU_COUNT
      libvirt.memory = MEMORY_MB
    end
    minion01.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install curl -y
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -A 192.168.100.120 -U stable 3006
      cat << EOF > /etc/salt/minion.d/grains.conf
grains:
  roles:
    - saltlab
EOF
      systemctl restart salt-minion
    SHELL
  end
  config.vm.define "minion02" do |minion02|
    minion02.vm.box = "peru/ubuntu-20.04-server-amd64"
    minion02.vm.hostname = "minion02"
    minion02.vm.network :private_network,
      :ip => "192.168.100.122",
      :libvirt__dhcp_enabled => false
    minion02.vm.provider :libvirt do |libvirt|
      libvirt.cpus = CPU_COUNT
      libvirt.memory = MEMORY_MB
    end
    minion02.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install curl -y
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -A 192.168.100.120 -U stable 3006
      cat << EOF > /etc/salt/minion.d/grains.conf
grains:
  roles:
    - saltlab
    - web
EOF
      systemctl restart salt-minion
    SHELL
  end
  config.vm.define "minion03" do |minion03|
    minion03.vm.box = "bento/rockylinux-8"
    minion03.vm.hostname = "minion03"
    minion03.vm.network :private_network,
      :ip => "192.168.100.123",
      :libvirt__dhcp_enabled => false
    minion03.vm.provider :libvirt do |libvirt|
      libvirt.cpus = CPU_COUNT
      libvirt.memory = MEMORY_MB
    end
    minion03.vm.provision "shell", inline: <<-SHELL
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -A 192.168.100.120 -U stable 3006
      systemctl enable salt-minion
      cat << EOF > /etc/salt/minion.d/grains.conf
grains:
  roles:
    - saltlab
EOF
      systemctl restart salt-minion
    SHELL
  end
  config.vm.define "minion04" do |minion04|
    minion04.vm.box = "rockylinux/9"
    minion04.vm.hostname = "minion04"
    minion04.vm.network :private_network,
      :ip => "192.168.100.124",
      :libvirt__dhcp_enabled => false
    minion04.vm.provider :libvirt do |libvirt|
      libvirt.cpus = CPU_COUNT
      libvirt.memory = MEMORY_MB
    end
    minion04.vm.provision "shell", inline: <<-SHELL
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -A 192.168.100.120 -U stable 3006
      cat << EOF > /etc/salt/minion.d/grains.conf
grains:
  roles:
    - saltlab
    - web
EOF
      systemctl restart salt-minion
    SHELL
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Salt lab environment with one master and four minions

Vagrant.configure("2") do |config|
  config.nfs.verify_installed = false
  config.vm.define "salt", primary: true do |salt|
    salt.vm.box = "peru/ubuntu-20.04-server-amd64"
    salt.vm.hostname = "salt"
    salt.vm.network "private_network", ip: "192.168.100.120"
    salt.vm.provider :libvirt do |libvirt|
      libvirt.memory = 1024
    end
    salt.vm.synced_folder 'srv', '/srv', type: 'rsync'
    salt.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install curl vim -y
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -M -X -U
      sed -i 's|^#auto_accept:.*$|auto_accept: True|' /etc/salt/master
      systemctl start salt-master
      systemctl start salt-minion
      sleep 5
      systemctl restart salt-master
    SHELL
  end
  config.vm.define "minion01" do |minion01|
    minion01.vm.box = "peru/ubuntu-20.04-server-amd64"
    minion01.vm.hostname = "minion01"
    minion01.vm.network "private_network", ip: "192.168.100.121"
    minion01.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install curl -y
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -A 192.168.100.120 -U
      cat << EOF > /etc/salt/minion.d/grains.conf
grains:
  roles:
    - saltlab
EOF
      systemctl restart salt-minion
    SHELL
  end
  config.vm.define "minion02" do |minion02|
    minion02.vm.box = "debian/bullseye64"
    minion02.vm.hostname = "minion02"
    minion02.vm.network "private_network", ip: "192.168.100.122"
    minion02.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install curl -y
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -A 192.168.100.120 -U
      cat << EOF > /etc/salt/minion.d/grains.conf
grains:
  roles:
    - saltlab
EOF
      systemctl restart salt-minion
    SHELL
  end
  config.vm.define "minion03" do |minion03|
    minion03.vm.box = "generic/rocky9"
    minion03.vm.hostname = "minion03"
    minion03.vm.network "private_network", ip: "192.168.100.123"
    minion03.vm.provision "shell", inline: <<-SHELL
      echo -n "> Waiting for network..."
      while ! host bootstrap.saltproject.io >/dev/null; do
        echo -n "."
        sleep 1
      done
      echo "Proceeding!"
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      # workaround for EL > 9 (https://github.com/saltstack/salt-bootstrap/issues/1903)
      sh bootstrap-salt.sh -A 192.168.100.120 -U -P -x python3 onedir
      cat << EOF > /etc/salt/minion.d/grains.conf
grains:
  roles:
    - saltlab
EOF
      systemctl restart salt-minion
    SHELL
  end
  config.vm.define "minion04" do |minion04|
    minion04.vm.box = "generic/centos7"
    minion04.vm.hostname = "minion04"
    minion04.vm.network "private_network", ip: "192.168.100.124"
    minion04.vm.provision "shell", inline: <<-SHELL
      echo -n "> Waiting for network..."
      while ! host bootstrap.saltproject.io >/dev/null; do
        echo -n "."
        sleep 1
      done
      echo "Proceeding!"
      curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
      sh bootstrap-salt.sh -A 192.168.100.120 -U
      cat << EOF > /etc/salt/minion.d/grains.conf
grains:
  roles:
    - saltlab
EOF
      systemctl restart salt-minion
    SHELL
  end
end

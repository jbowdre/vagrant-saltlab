# vagrant-saltlab

Using [HashiCorp Vagrant](https://github.com/hashicorp/vagrant) to run a portable, redeployable [Salt](https://saltproject.io/) lab environment [on my Chromebook](https://runtimeterror.dev/create-vms-chromebook-hashicorp-vagrant/).

The included Vagrantfile spawns a environment with a single Salt Master (named `salt`) and four Salt Minions (named `minion##`) running different common Linux distributions for learning, testing, and development. It leverages the [`libvirt` provider](https://github.com/vagrant-libvirt/vagrant-libvirt) to interact with native Linux virtualization, and has a few tweaks to work around limitations imposed by running this all within ChromeOS's LXC-based [Linux development environment](https://support.google.com/chromebook/answer/9145439).

To make it easier to deploy, test, break, tear down, and redeploy the environment:
- The Salt master blindly auto-accepts all minion keys.
- The minions register the `roles:saltlab` grain to aid in targeting.
- The master uses `gitfs` to pull the starter Salt content from this very Github repo.
- Additionally, the contents of `salt_content/local` get `rsync`ed to `/srv/` when the master starts up to make it easier to write/test Salt content locally. This is a one-way `rsync` from host to VM (and not the other way around), so make sure to write your Salt content on the host and use `vagrant rsync` to push changes into the VM.

## Preparation
See [the blog post](https://runtimeterror.dev/create-vms-chromebook-hashicorp-vagrant/) for full details on how I've configured my environment.

<details><summary>Here's the crash course:</summary>

1. Verify support for nested virtualization:
```shell
ls -l /dev/kvm
```
2. Install prerequisites:
```shell
sudo apt update && sudo apt install \
  build-essential \
  gpg \
  lsb-release \
  rsync \
  wget
```
3. Install `virt-manager` and `libvirt-dev`:
```shell
sudo apt install virt-manager libvirt-dev
```
4. Configure libvirt:
```shell
sudo gpasswd -a $USER libvirt ; newgrp libvirt
echo "remember_owner = 0" | sudo tee -a /etc/libvirt/qemu.conf
echo "namespaces = []" | sudo tee -a /etc/libvirt/qemu.conf
sudo systemctl restart libvirtd
```
5. Install Vagrant
```shell
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vagrant
```
6. Install `vagrant-libvirt` plugin:
```shell
vagrant plugin install vagrant-libvirt
```
</details>

## Usage

Clone this repo:
```shell
git clone https://github.com/jbowdre/vagrant-saltlab.git
cd vagrant-saltlab
```

Review the Vagrantfile, and adjust `CPU_COUNT` and `MEMORY_MB` if needed. Note that some of the machines won't function correctly with less than `1024` MB.
```shell
vim Vagrantfile
```

Provision the virtual environment:
```shell
vagrant up
```

The master and four minions will be deployed; this will take several minutes. Once complete, you can verify status with `vagrant status`:
```shell
vagrant status
Current machine states:

salt           running (libvirt)  # master, ubuntu 22.04
minion01       running (libvirt)  # ubuntu 22.04
minion02       running (libvirt)  # ubuntu 20.04
minion03       running (libvirt)  # rocky 8
minion04       running (libvirt)  # rocky 9

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

Access an SSH shell on the master with `vagrant ssh salt`:
```shell
vagrant ssh salt
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-83-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

  System information as of Tue Feb  6 04:28:02 PM UTC 2024

  System load:  0.072265625        Processes:             104
  Usage of /:   14.3% of 30.34GB   Users logged in:       0
  Memory usage: 59%                IPv4 address for eth0: 192.168.121.69
  Swap usage:   0%                 IPv4 address for eth1: 192.168.100.120


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue Feb  6 14:37:44 2024 from 192.168.121.1
vagrant@salt:~$
```

Verify that all the minion keys have been automatically accepted by the master (this is a lab environment, after all):
```shell
vagrant@salt:~$ sudo salt-key -L
Accepted Keys:
minion01
minion02
minion03
minion04
salt
Denied Keys:
Unaccepted Keys:
Rejected Keys:
```

Make sure all the minions are responding correctly:
```shell
vagrant@salt:~$ sudo salt '*' test.ping
salt:
    True
minion03:
    True
minion02:
    True
minion01:
    True
minion04:
    True
```

And confirm that the local and remote content has been successfully merged into the `salt://` file system:
```shell
vagrant@salt:~$ sudo salt-run fileserver.file_list
- _reactor/sync_grains.sls    # gitfs
- neofetch/init.sls           # local
- neofetch/uninstall.sls      # local
- top.sls                     # gitfs
- users/init.sls              # gitfs
- vim/init.sls                # gitfs
- vim/uninstall.sls           # gitfs
- vim/vimrc                   # gitfs
- webserver/index.html        # gitfs
- webserver/init.sls          # gitfs
- webserver/uninstall.sls     # gitfs
```

You can then apply a state like so:
```shell
vagrant@salt:~$ sudo salt '*' state.apply neofetch
```

Happy Salting!

## Cleanup
To blow it all away for a fresh start, just run `vagrant destroy -f`. You can then re-do `vagrant up`.

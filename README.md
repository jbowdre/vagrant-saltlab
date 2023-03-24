# vagrant-saltlab

Using Vagrant to run a portable [Salt](https://saltproject.io/) lab environment [on my Chromebook](https://www.virtuallypotato.com/create-vms-chromebook-hashicorp-vagrant/). The included Vagrantfile spawns a environment with a single Salt Master (named `salt`) and four Salt Minions (named `minion##`) running a few different common Linux distributions for learning, testing, and development. It leverages the `libvirt` provider to interact with native Linux virtualization, and has a few tweaks to work around limitations imposed by running this all within ChromeOS's LXC-based [Linux development environment](https://support.google.com/chromebook/answer/9145439).

To make it easier to deploy, test, break, tear down, and redeploy the environment:
1. The Salt master blindly auto-accepts all minion keys.
2. The minions register the `roles:saltlab` grain to aid in targeting.
3. The contents of `srv/` get `rsync`ed to `/srv/` when the master starts up. *Note that this is a one-way `rsync` from host to VM (and not the other way around), so make sure to write your Salt content on the host and use `vagrant rsync` to push changes into the VM.*

## Usage

Provision the virtual environment:
```shell
vagrant up
```

The master and four minions will be deployed; this will take a few minutes. Once complete, you can verify status with `vagrant status`:
```shell
; vagrant status
Current machine states:

salt                      running (libvirt)
minion01                  running (libvirt)
minion02                  running (libvirt)
minion03                  running (libvirt)
minion04                  running (libvirt)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

Access an SSH shell on the master with `vagrant ssh salt`:
```shell
; vagrant ssh salt
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-139-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
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

And finally, as a treat, apply a [Salt state to install vim and my vimrc](srv/salt/vim/init.sls) on the minions with the `roles:saltlab` grain:
```shell
sudo salt -G 'roles:saltlab` state.apply vim
```

To blow it all away for a fresh start, just run `vagrant destroy -f`.

Happy Salting!

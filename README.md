# vagrant-saltlab

Using Vagrant to run a portable [Salt](https://saltproject.io/) lab environment [on my Chromebook](https://www.virtuallypotato.com/create-vms-chromebook-hashicorp-vagrant/). The included Vagrantfile spawns a environment with a single Salt Master (named `salt`) and four Salt Minions (named `minion##`) running a few different common Linux distributions for learning, testing, and development. It leverages the `libvirt` provider to interact with native Linux virtualization, and has a few tweaks to work around limitations imposed by running this all within ChromeOS's LXC-based [Linux development environment](https://support.google.com/chromebook/answer/9145439).

To make it easier to deploy, test, break, tear down, and redeploy the environment:
1. The Salt master blindly auto-accepts all minion keys.
2. The minions register the `roles:saltlab` grain to aid in targeting.
3. The master uses `gitfs` to pull the Salt content from this very Github repo.
4. Additionally, the contents of `salt_content/local` get `rsync`ed to `/srv/` when the master starts up to make it easier to write/test Salt content locally. This is a one-way `rsync` from host to VM (and not the other way around), so make sure to write your Salt content on the host and use `vagrant rsync` to push changes into the VM.


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

And confirm that the local and remote content has been successfully merged into the `salt://` file system:
```shell
vagrant@salt:~$ sudo salt-run fileserver.file_list
- _reactor/sync_grains.sls    # gitfs
- acg/.gitkeep                # local
- acg/neofetch/init.sls       # local
- acg/neofetch/uninstall.sls  # local
- acg/top.sls                 # local
- top.sls                     # gitfs
- users/init.sls              # gitfs
- vim/init.sls                # gitfs
- vim/uninstall.sls           # gitfs
- vim/vimrc                   # gitfs
- webserver/index.html        # gitfs
- webserver/init.sls          # gitfs
- webserver/uninstall.sls     # gitfs
```

Happy Salting!

## Cleanup
To blow it all away for a fresh start, just run `vagrant destroy -f`.

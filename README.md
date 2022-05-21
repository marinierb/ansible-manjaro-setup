# Ansible Manjaro Setup

![GitHub last commit](https://img.shields.io/github/last-commit/marinierb/ansible-manjaro-setup)

## Custom configure my personal Manjaro desktop

- Can be used to build from scratch or to fix or restore broken stuff.
- Installs and configures all software, peripherals, etc.
- Any change that I make to my system is automated in here.
- I could make system backups instead, but how much fun is that? This is way cooler!
- Includes scripts that create backups of a few things so that they can be restored via ansible.

## I hope this can be useful to others

There are some neat roles in here. Steal with pride!

## Note about VPN split-tunneling

**expressvpn** does not support split-tunneling on Linux. So I have created a role called **novpn** that:
- Creates a service called **novpn**<br>
This service automatically creates, at startup, a network namespace outside of the VPN tunnel.<br>
I can then run applications in that namespace to bypass the VPN.
- Creates some local desktop launchers for **chrome** and **firefox**<br>
These override the default launchers.<br>
They allow me to launch those browsers inside that namespace (outside of the VPN).

## Steps to rebuild my desktop from scratch

>**In a nutshell:**
><br>My ansible folder is on Dropbox. So, get Manjaro up and running, install and sync Dropbox, then run ansible.

1. Install the [GNOME edition of Manjaro](https://manjaro.org/download/#gnome)

1. Update mirror list

        sudo pacman-mirrors

      or more specifically, for me

        sudo pacman-mirrors -c Canada United_States

1. Update all packages

        sudo pacman -Syyu

1. Reboot

1. Enable [aur](https://wiki.archlinux.org/index.php/Arch_User_Repository)

        → Open the Package Manager (search for Add/Remove Software)
        → Navigate to the Preferences page (you will be required to enter your password to access it)
        → At Preferences page → select the AUR tab → and move the slider to enable AUR

1. Install ansible and requisites

        sudo pacman -S ansible python-psutil
        pamac build ansible-aur-git

1. Create required secrets

        secret-tool store --label='password' main password
        secret-tool store --label='vpnUsername' vpn username
        secret-tool store --label='vpnPassword' vpn password

1. Install Dropbox and set it up

        pamac build dropbox

1. Wait for Dropbox sync to finish

1. Go to ***Dropbox/Linux/ansible*** directory

1. Review the playbooks and the inventory

1. Review the backups folder (see backups below)

1. Run the ansible script!

        ./an

1. Reboot

## Steps to run a single role

This will configure a single element such as a software package or a system setting.

        → Look for the appropriate tag in the main playbook
        → From the ansible directory, run the ansible script with that tag as a parameter
Example:
```
./an libreoffice
```

## About the ansible script

The ***an*** script has a few options to verify things:

```
./an -h
usage: an [option] [tags]
  options: -t list tasks
           -l list hosts
           -c check
```

## About backups

Some roles look for corresponding backups and restore them. The backups are created using ansible via the ***backup*** script and a series of roles in the ***backups*** directory.

> **NOTE**
> <br>To avoid restoring backups unless absolutely necessary, a string can be appended to the backup names to hide them from the restore tasks.
> <br>In ***inventory.xml***, set the variable *skipRestore* to any string i.e. ".skiprestore". That string will be appended to each backup name by the backup tasks.
> <br>Manually remove this string from the backup's name if a restore is in fact desired.

### To run a backup

        → Look for the appropriate tag in the backups playbook
        → Run the backup script with that tag
        → Or don't specify a tag to back up everything

Example:
```
./backup libreoffice
```

### To restore a configuration from a backup

        → Look for the appropriate tag in the main playbook
        → Remove any "skip" string appended to the name of the backup
        → Run the ansible script with that tag

Example:
```
mv backups/libreoffice.zip.skiprestore backups/libreoffice.zip
./an libreoffice
```
### For a full run of the ansible build

        → Remove any "skip" string from all of the backups
        → Run the ansible script

## Notes
- To install public key on a remote host
```
cat ~/.ssh/id_rsa.pub | ssh user@host 'cat >> .ssh/authorized_keys'
```
---

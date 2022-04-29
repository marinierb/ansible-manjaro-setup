# Ansible Manjaro Setup

![GitHub last commit](https://img.shields.io/github/last-commit/marinierb/ansible-manjaro-setup)

## Custom configure my personal Manjaro desktop and laptop

- Can be used to build from scratch or to fix or restore broken stuff.
- Installs and configures all software, peripherals, etc.
- Any change that I make to my system is automated in here.
- I could make system backups instead, but how much fun is that? This is way cooler!
- Includes scripts that create backups of a few things so that they can be restored via ansible.

## I hope this can be useful to others

There are some neat roles in here. Steal with pride!

## Note

I run expressvpn. Because it does not support split-tunneling, I created a service called **novpn** that creates a namespace outside of the VPN tunnel.
Then I created some local desktop launchers for chrome and firefox to run the browsers in that namespace. This is useful for web sites that block access from VPNs.

## Steps to rebuild from scratch

>**In a nutshell:**
><br>My ansible folder is on Dropbox. So, get Manjaro up and running, install and sync Dropbox, then run ansible

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

Some roles will attempt to recover data and configurations from backups. These roles look for corresponding backup directories and restore from them.

> **NOTE**
> <br>To avoid restoring backups unless absolutely necessary, a string can be appended to the backup directory names to hide them from the restore tasks.
> <br>In ***inventory.xml***, set the variable *skipRestore* to any string i.e. ".skiprestore". That string will be appended to each backup directory name by the backup tasks.
> <br>Manually remove this string from the backup directory name if a restore is in fact desired.

The backups are created using ansible via the ***backup*** script and a series of roles and data directories in the ***backups*** directory.

- To run a backup
```
./backup [tag] (see backups playbook for tags)
```

The ***gnome*** backup, however, works differently. It extracts specific gnome settings and creates ansible tasks directly in the *gnome* role. These tasks are extensively tagged so that specific settings can be restored.

## Notes
- To install public key on a remote host
```
cat ~/.ssh/id_rsa.pub | ssh user@host 'cat >> .ssh/authorized_keys'
```
---

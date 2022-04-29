#!/usr/bin/sh
# Installs the virtualbox extension pack
v=`vboxmanage -v | cut -d'r' -f1`
if ! wget -q -P /tmp "https://download.virtualbox.org/virtualbox/$v/Oracle_VM_VirtualBox_Extension_Pack-${v}.vbox-extpack"
then
  echo "--> ERROR: Failed to download virtualbox ext pack!"
  exit 1
fi
echo "--> INFO: virtualbox ext pack successfully downloaded."
echo y | VBoxManage extpack install --replace /tmp/Oracle_VM_VirtualBox_Extension_Pack-${v}.vbox-extpack >/dev/null 2>&1
if [ $? != 0 ]
then
  echo "--> ERROR: Failed to install virtualbox ext pack!"
  exit 1
fi
echo -e "--> INFO: virtualbox ext pack successfully installed."
rm /tmp/Oracle_VM_VirtualBox_Extension_Pack-${v}.vbox-extpack

#!/usr/bin/sh
# Installs the virtualbox extension pack
v=`vboxmanage -v | cut -d'r' -f1`
pack=Oracle_VM_VirtualBox_Extension_Pack-$v.vbox-extpack
if ! wget -q -P /tmp "https://download.virtualbox.org/virtualbox/$v/$pack"
then
  echo "--> ERROR: Failed to download virtualbox ext pack!"
  exit 1
fi
echo "--> INFO: virtualbox ext pack successfully downloaded."
echo y | VBoxManage extpack install --replace /tmp/$pack >/dev/null 2>&1
if [ $? != 0 ]
then
  echo "--> ERROR: Failed to install virtualbox ext pack!"
  exit 1
fi
echo -e "--> INFO: virtualbox ext pack successfully installed."
rm /tmp/$pack

#! /bin/bash

#Check root 
if [[ $EUID -ne 0 ]]
then
	sudo chmod +x $(dirname $0)/$0
	sudo $(dirname $0)/$0
	exit;
fi

######## Script ################
# Greeter and Faster DNF
isfm=$(grep -c fastestmirror /etc/dnf/dnf.conf)
if [[ "$isfm" -eq "0" ]]
then
	echo "fastestmirror=1" >> /etc/dnf/dnf.conf
fi 

#Fsync-Kernel
dnf copr enable sentry/kernel-fsync

#Mesa-aco
dnf copr enable gloriouseggroll/mesa-aco 

# RPM Fusion
dnf install --nogpgcheck -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
if [[ "$removepackagekit" -ne "1" ]]
then
	dnf install --nogpgcheck -y rpmfusion-free-appstream-data rpmfusion-nonfree-appstream-data
fi

# Upgrade
dnf -y --nogpgcheck --refresh upgrade

#Gaming-Flatpak
git clone https://github.com/Chevek/Gaming-Flatpak.git
cd Gaming-Flatpak/
./gaming-flatpak.sh
cd ..
cd ..
rm FedoraFlatpakGaming-main

echo "It is done, reboot please!"

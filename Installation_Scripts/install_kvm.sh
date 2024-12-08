#!/bin/bash
# Author: Sharad Chhetri
# Blog: https://sharadchhetri.com
# Description: Install KVM on Ubuntu
# Resources: Ubuntu 24.04 LTS, Ubuntu 22.04 LTS, Ubuntu 20.04 LTS
#

_cpu_count=$(egrep -c '(vmx|svm)' /proc/cpuinfo)

echo '## Check Virtualisation Technology ##'
if [ "$_cpu_count" -lt 1 ]
then
	echo "Checked CPU, Virtualization Technology does not support."
	exit 1
else
	echo "Checked CPU, Virtualization Technology support in this Operating System"

fi

sudo apt -y update

echo '## Install packages ##'
sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon libvirt-daemon-system qemu qemu-kvm qemu-system

echo '## Add user ##'
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

echo '### List VM ###'
virsh list --all

echo '#### Install virt-manager for GUI ###'
sudo apt -y install virt-manager

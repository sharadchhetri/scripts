#!/bin/bash
# Description: Install Docker On CentOS 8
# Tutorial: https://sharadchhetri.com/2020/06/09/how-to-install-docker-on-centos-8/

sudo sed -i.bak 's/enforcing/disabled/g' /etc/selinux/config 
sudo setenforce 0
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io --nobest
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
sudo systemctl disable firewalld

#!/bin/bash
# Description: Install Docker On CentOS 8
# Blog: https://sharadchhetri.com

sudo sed -i.bak 's/enforcing/disabled/g' /etc/selinux/config 
sudo setenforce 0
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io --nobest
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
sudo systemctl disable firewalld

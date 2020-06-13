#!/bin/bash
# Description: Install docker on Ubuntu
# Tested: On Ubuntu 20.04 LTS, x86_64
# Tutorial: https://sharadchhetri.com/2020/06/07/install-docker-on-ubuntu/
#
# Docker Supported Architecture: x86_64 (or amd64), armhf, arm64, s390x and ppc64le
#

_arch=$(arch)
sudo apt -y update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=$_arch] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get -y update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${USER}

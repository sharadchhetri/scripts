#!/bin/bash
# Author: Sharad Chhetri
# Description: A very simple bash script for installing Ansible in Ubuntu.
#
sudo apt -y update
sudo apt -y install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt -y install ansible
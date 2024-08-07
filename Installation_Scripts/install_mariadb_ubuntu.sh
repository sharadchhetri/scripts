#!/bin/bash
# Created Date: 7/Aug/2024
# Description: This bash script will install MariaDB version 10.11 in Ubuntu machine. 
# Author: Sharad Chhetri
# Blog: https://sharadchhetri.com

_mariadb_version=10.11
_ubuntu_release_code=$(lsb_release -cs)

# Using US Giganet Apt Repository
sudo apt-get install apt-transport-https curl
sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c "echo 'deb https://mirrors.gigenet.com/mariadb/repo/$_mariadb_version/ubuntu $_ubuntu_release_code main' >>/etc/apt/sources.list"

sudo apt-get update
sudo apt-get -y install mariadb-server mariadb-client

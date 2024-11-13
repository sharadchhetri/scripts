#!/bin/bash
# Created Date: 7/Aug/2024
# Updated On: 13/Nov/2024
# Description: This bash script will install MariaDB version 11.7 in Ubuntu machine. 
# Author: Sharad Chhetri
# Blog: https://sharadchhetri.com

_mariadb_version=11.5
_ubuntu_release_code=$(lsb_release -cs 2>/dev/null)

# Using US Giganet Apt Repository
sudo apt-get -y install apt-transport-https curl
sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c "echo 'deb https://mirrors.gigenet.com/mariadb/repo/$_mariadb_version/ubuntu $_ubuntu_release_code main' >>/etc/apt/sources.list"

sudo apt-get -y update
sudo apt-get -y install mariadb-server mariadb-client

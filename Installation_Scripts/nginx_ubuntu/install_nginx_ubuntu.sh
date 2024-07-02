#!/bin/bash

# Description: This script will install the nginx in Ubuntu Servers
# Created By: Sharad Chhetri
# Date: 05-Mar-2023
# Blog: https://sharadchhetri.com

_package="nginx"
_signing_key_url=https://nginx.org/keys/nginx_signing.key


# Check if nginx is installed or not. A good example for learner - how to use the if condition.

if [ $(dpkg-query -W -f='${Status}' $_package 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  # Install Dependency
  sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y

  # Add Signing Key
  curl $_signing_key_url| gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

  # Create Apt Repo File
  echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list

  # Set Preference
  echo  "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx

 # Install Nginx
  sudo apt update -y
  sudo apt -y install $_package

 # Restart the nginx service
  sudo systemctl restart nginx
fi

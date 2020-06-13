#/bin/bash
#
# Install MariaDB Server version 10.4 on CentOS 8.
# Blog: https://sharadchhetri.com

cat <<EOF >mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos8-amd64
module_hotfixes=1
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
sudo mv mariadb.repo /etc/yum.repos.d/
sudo dnf install MariaDB-server
sudo systemctl enable --now mariadb

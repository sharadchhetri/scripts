#/bin/bash
#
# Install MariaDB Server version 10.4 on CentOS 8.
# Blog: https://sharadchhetri.com

# Declare a variable for new mariadb root password. If it is not given, then script won't run and will show help.
#

_root_new_passwd=${1?Require to give new root password, use -n }

# create new yum mariadb repo file and move to /etc/yum.repos.d dir
cat <<EOF >mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos8-amd64
module_hotfixes=1
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
sudo mv mariadb.repo /etc/yum.repos.d/

#Install MariaDB Server
sudo dnf install -y MariaDB-server

# Enable as well as Start the mariadb service
sudo systemctl enable --now mariadb

## Resetting root password, removing database called 'test' and any related tables to it
sudo mariadb <<_EOF_
ALTER USER root@localhost IDENTIFIED VIA mysql_native_password USING PASSWORD("$_root_new_passwd");
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

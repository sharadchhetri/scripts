#/bin/bash
#
# Install jfrog on CentOS 8
# Tutorial URL: https://sharadchhetri.com/2020/06/13/how-to-install-jfrog-artifactory-on-centos-8/

# Disable the SELINUX on CentOS 8
# set temporary permissive selinux mode. reboot not require
sudo setenforce 0
# In next reboot,the below line will help to set disable selinux permanently.
sudo sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config

# jfrog oss 7.x require Java 11, installing wget and openjdk
sudo yum install -y wget java-11-openjdk*

# download jfrog repo and directly keep in /etc/yum.repos.d dir
sudo wget https://bintray.com/jfrog/artifactory-rpms/rpm -O /etc/yum.repos.d/bintray-jfrog-artifactory-oss-rpms.repo

# install jfrog-artifactory-oss (open source)
sudo yum install -y jfrog-artifactory-oss

# yaml files are indent sensitive. So do not remove spaces while copying. Keep as it is.
# creating system.yaml
cat <<EOF >system.yaml
configVersion: 1
shared:
    extraJavaOpts: "-server -Xms512m -Xmx2g -Xss256k -XX:+UseG1GC"
    security:
    node:
    database:
EOF

# copying above created system.yaml and replacing by original one 
sudo cp -brvf system.yaml /var/opt/jfrog/artifactory/etc/system.yaml

# enable artifactoyr.service as well as start the service at a same time
sudo systemctl enable --now artifactory

# Now open web browser - http://<jfrog-ip-or-fqdn>:8081 and do the post setup of jfrog.

#/bin/bash
#
# Install Jenkins On CentOS 6,7 and 8 by using jenkins.war file.
# Note: here, we are using OpenJDK  
#
sudo yum install -y wget
yum installi -y java-1.8.0-openjdk

sudo useradd -d /home/jenkins -m jenkins
sudo usermod -s /bin/bash jenkins

sudo mkdir -p /opt/jenkins

sudo wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war -P /opt/jenkins/

sudo chown jenkins:jenkins /opt/jenkins/jenkins.war
sudo chmod +x /opt/jenkins/jenkins.war


cat <<EOF >jenkins.service
[Unit] 
Description=Jenkins Daemon 
[Service] 
ExecStart=java -jar /opt/jenkins/jenkins.war 
User=jenkins 
[Install] 
WantedBy=multi-user.target
EOF

sudo mv jenkins.service /etc/systemd/system/jenkins.service

sudo chmod 755 /etc/systemd/system/jenkins.service

sudo setenforce 0

sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins

sudo sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config

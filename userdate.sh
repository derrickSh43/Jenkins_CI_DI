#!bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-11-jdk -y
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.95/bin/apache-tomcat-9.0.95.tar.gz
sudo tar -xf apache-tomcat-9.0.95.tar.gz
sudo mv apache-tomcat-9.0.95 /opt/tomcat
sudo chmod +x /opt/tomcat/bin/*.sh
/opt/tomcat/bin/startup.sh
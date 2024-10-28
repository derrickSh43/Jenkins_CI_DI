#!/bin/bash
systemctl enable jenkins  # Enable Jenkins to start on boot
systemctl start jenkins  # Start Jenkins service
cat /var/lib/jenkins/secrets/initialAdminPassword #Get initial admin password
password=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "{\"initialAdminPassword\": \"$password\"}"
#!/bin/bash

set -e

echo "🔹 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "🔹 Installing Docker..."
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

echo "🔹 Adding current user to Docker group..."
sudo usermod -aG docker $USER

echo "🔹 Installing Java 17 (Required for Jenkins)..."
sudo apt install -y openjdk-17-jdk

echo "🔹 Setting up Jenkins repository..."
sudo mkdir -p /etc/apt/keyrings

sudo wget -q -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔹 Installing Jenkins..."
sudo apt update
sudo apt install -y jenkins

echo "🔹 Starting Jenkins..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "🔹 Allowing Jenkins to use Docker..."
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

echo "🔹 Installing Docker Compose plugin..."
sudo apt install -y docker-compose-plugin

echo "✅ SETUP COMPLETE!"
echo "➡️ Re-login OR run: newgrp docker"
echo "➡️ Jenkins URL: http://SERVER-IP:8080"
echo "➡️ Jenkins password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

#!/bin/bash

# Installs Jenkins on the deployment server

# Update package list
sudo apt-get update

# Install necessary packages to use HTTPS repositories
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y

# Install Java 17
yes | sudo apt-get install openjdk-21-jre-headless

# Download Jenkins key and add it to system
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins to system package source list
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package lists again to include Jenkins and install
yes | sudo apt-get update
yes | sudo apt-get install -y jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Start Jenkins
sudo systemctl start jenkins


# Update package list
sudo apt-get update

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository to sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list for the addition to be recognized
sudo apt-get update

# Install Docker CE
sudo apt-get install docker-ce -y

# Create docker group
sudo groupadd -g 972 docker

# Add the jenkins user to the docker group
sudo usermod -aG docker jenkins

# Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Set executable permission on docker-compose binary
sudo chmod +x /usr/local/bin/docker-compose

# Restart so that Jenkins server runs with the new group membership
sudo systemctl restart jenkins

#Enanble docker to start on boot
sudo systemctl enable docker

# Start Docker
sudo systemctl start docker

#Install nodejs and its package manager npm/yarn
sudo apt install nodejs -y
sudo apt install npm -y
sudo npm install -g corepack
corepack prepare yarn@4.2.2 --activate
#Install maven
sudo apt install maven -y

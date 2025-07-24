#!/bin/bash
# This script installs Docker on a ubuntu system using apt package manager.

set -e

echo "**************************************"
echo "Updating the system..."
echo "**************************************"
sudo apt-get update && sudo apt-get upgrade -y

echo "**************************************"
echo "Installing prerequisites..."
echo "**************************************"
sudo apt-get install -y curl ca-certificates gnupg lsb-release

echo "**************************************"
echo "Adding Docker's official GPG key..."
echo "**************************************"
sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg  |\
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "**************************************"
echo "Allocating the read permissions for the keyring to all users..."
echo "**************************************"

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "**************************************"
echo "Adding Docker's official APT repository to your Ubuntu system..."
echo "**************************************"

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg]  https://download.docker.com/linux/ubuntu \
 $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable | \
 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null "


echo "**************************************"
echo "Updating after adding Docker's repository..."
echo "**************************************"
sudo apt-get update -y

echo "**************************************"
echo "Installing Docker packages..."
echo "**************************************"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


echo "==========================================="
echo "Post-installation steps..."
echo "==========================================="

echo 
echo 

echo "***************************************"
echo "Creating the docker group..."
echo "***************************************"

sudo groupadd docker


echo "***************************************"
echo "Add your user to the docker group."
echo "***************************************"
sudo usermod -aG docker $USER
newgrp docker


echo "***************************************"
echo "Configuring Docker to start on boot..."
echo "***************************************"
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

docker --version
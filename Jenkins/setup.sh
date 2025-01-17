#!/bin/bash

# Exit immediately if any command fails
#set -e

# Update the system and install dependencies
echo "Updating system packages..."
sudo apt update -y
sudo apt install -y fontconfig openjdk-17-jre wget gnupg

# Verify Java installation
echo "Verifying Java installation..."
java -version

# Add Jenkins repository key
echo "Adding Jenkins repository key..."
sudo wget -q -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io.key

# Add Jenkins repository to APT sources
echo "Adding Jenkins repository..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable/ binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list to include Jenkins
echo "Updating package list..."
sudo apt update -y

# Install Jenkins
echo "Installing Jenkins..."
sudo apt install -y jenkins

# Ensure Jenkins has correct permissions for its directories
#echo "Setting Jenkins directory permissions..."
#sudo chown -R jenkins:jenkins /var/lib/jenkins /var/log/jenkins /var/cache/jenkins
#sudo chmod -R 755 /var/lib/jenkins /var/log/jenkins /var/cache/jenkins

# Grant Jenkins user necessary permissions to run services
echo "Granting Jenkins user permission to run services..."
sudo usermod -aG sudo jenkins

# Start Jenkins service and enable it to start at boot
echo "Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Jenkins service status
echo "Checking Jenkins service status..."
sudo systemctl status jenkins

# Open the necessary port (8080) on the firewall (if applicable)
echo "Configuring firewall to allow port 8080..."
sudo ufw allow 8080

# Output message with instructions for unlocking Jenkins
echo "Jenkins installation complete!"
echo "To unlock Jenkins, retrieve the initial admin password with the following command:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo "Then, open your browser and go to http://<your_server_ip>:8080"

#!/bin/bash

cd /var/www/html || { echo "Error: Unable to navigate to /var/www/html"; exit 1; }

# Check if package.json exists
if ! find . -type f -name "package.json" | grep -q "package.json"; then
    echo "Error: package.json not found. Build skipped."
    exit 1
fi

# Setup Node.js
echo "Setting up Node.js environment..."
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Install dependencies
echo "Installing dependencies..."
sudo -u ec2-user npm install

sudo npm install -g typescript

# Check if ts-node is installed
if ! command -v ts-node &> /dev/null; then
    echo "Error: ts-node is not installed. Installing globally..."
    sudo npm install -g ts-node
else
    echo "ts-node is already installed."
fi

# Fix permissions for ts-node
sudo chmod +x /var/www/html/node_modules/.bin/ts-node

# Build application
echo "Building the application..."
sudo -u ec2-user npm run build

echo "Dependency installation completed successfully."

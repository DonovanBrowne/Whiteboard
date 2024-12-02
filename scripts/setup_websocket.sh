#!/bin/bash

cd /var/www/html || { echo "Error: Unable to navigate to /var/www/html"; exit 1; }

# Set environment variables
echo "export INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> ~/.bashrc
source ~/.bashrc

# Ensure proper permissions
sudo chown -R ec2-user:ec2-user /var/www/html

# Install PM2 if not present
if ! command -v pm2 &> /dev/null; then
    echo "PM2 is not installed. Installing PM2..."
    sudo npm install -g pm2
else
    echo "PM2 is already installed."
fi

echo "Starting WebSocket server..."
# Start WebSocket server with PM2 using npm
sudo pm2 start npm --name websocket-server -- run websocket -- --host 0.0.0.0 --port 3000

exit 0

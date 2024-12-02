#!/bin/bash

cd /var/www/html || { echo "Error: Unable to navigate to /var/www/html"; exit 1; }

# Ensure proper permissions
sudo chown -R ec2-user:ec2-user /var/www/html

# Install PM2 if not present
if ! command -v pm2 &> /dev/null; then
    echo "PM2 is not installed. Installing PM2..."
    sudo npm install -g pm2
else
    echo "PM2 is already installed."
fi

# Clean up existing PM2 processes and logs
echo "Cleaning up PM2 processes and logs..."
sudo pm2 delete all
sudo pm2 flush

# Start WebSocket server with the correct ts-node configuration
echo "Starting WebSocket server..."
sudo pm2 start ts-node --name websocket-server -- src/web-socket-server.ts --host 0.0.0.0 --port 3000 --node-args="--loader ts-node/esm"

exit 0
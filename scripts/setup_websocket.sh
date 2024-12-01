#!/bin/bash
cd /var/www/html

# Set environment variables
echo "export INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> ~/.bashrc
source ~/.bashrc

if ! command -v pm2 &> /dev/null; then
    echo "PM2 is not installed. Installing PM2..."
    sudo npm install -g pm2
else
    echo "PM2 is already installed."
fi

# Start WebSocket server with PM2
pm2 delete websocket-server 2>/dev/null || true
pm2 start src/web-socket-server.ts --name websocket-server

# Save PM2 configuration
pm2 save

# Configure PM2 to start on boot 
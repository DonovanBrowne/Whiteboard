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

if sudo pm2 list | grep -q "websocket-server"; then
    # Check if the process is actually online
    if sudo pm2 list | grep "websocket-server" | grep -q "online"; then
        echo "WebSocket server is running and online."
    else
        echo "WebSocket server exists but is not online. Restarting..."
        sudo pm2 delete websocket-server
        sudo pm2 start npm --name websocket-server -- run websocket -- --host 0.0.0.0 --port 3000
    fi
else
    echo "Starting WebSocket server..."
    sudo pm2 start npm --name websocket-server -- run websocket -- --host 0.0.0.0 --port 3000
fi

exit 0
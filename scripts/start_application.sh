#!/bin/bash

cd /var/www/html || { echo "Error: Unable to navigate to /var/www/html"; exit 1; }

# Ensure proper permissions
sudo chown -R ec2-user:ec2-user /var/www/html

# Install dependencies
npm install vite

# Install PM2 if not present
if ! command -v pm2 &> /dev/null; then
    echo "PM2 is not installed. Installing PM2..."
    sudo npm install -g pm2
else
    echo "PM2 is already installed."
fi

if sudo pm2 list | grep -q "vite"; then
    # Check if the process is actually online
    if sudo pm2 list | grep "vite" | grep -q "online"; then
        echo "Main application is running and online."
    else
        echo "Main application exists but is not online. Restarting..."
        sudo pm2 delete vite
        sudo pm2 start npm --name vite -- run dev -- --host 0.0.0.0 --port 80
    fi
else
    echo "Starting main application..."
    sudo pm2 start npm --name vite -- run dev -- --host 0.0.0.0 --port 80
fi

exit 0
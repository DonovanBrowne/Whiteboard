#!/bin/bash

cd /var/www/html || { echo "Error: Unable to navigate to /var/www/html"; exit 1; }

# Start application
sudo chown -R ec2-user:ec2-user /var/www/html
npm install vite

if ! command -v pm2 &> /dev/null; then
    echo "PM2 is not installed. Installing PM2..."
    sudo npm install -g pm2
else
    echo "PM2 is already installed."
fi

echo "Starting application..."
sudo pm2 start npm --name vite -- run dev -- --host 0.0.0.0 --port 80
exit 0

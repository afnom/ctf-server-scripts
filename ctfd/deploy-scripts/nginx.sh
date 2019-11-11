#!/bin/bash

# install dependencies
apt update
apt install nginx -y

# modify general nginx settings
cp /opt/assets/nginx.conf /etc/nginx/conf.d/main.conf

# install site
rm /etc/nginx/sites-enabled/default
cp /opt/assets/ctfd.conf /etc/nginx/sites-available/ctfd
ln -s /etc/nginx/sites-available/ctfd /etc/nginx/sites-enabled/

# restart nginx
sudo systemctl restart nginx

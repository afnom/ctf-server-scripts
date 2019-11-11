#!/bin/bash

# install dependencies
apt update
apt install docker.io docker-compose -y

# download ctfd
cd /opt
git clone https://github.com/CTFd/CTFd.git
cd CTFd

# remove old instance
docker-compose down
rm -rf .data

# start instance
python -c "import os; f=open('.ctfd_secret_key', 'a+'); f.write(os.urandom(64)); f.close()"
docker-compose up -d

# wait for it to startup
echo "Waiting for CTFd startup..."
sleep 30

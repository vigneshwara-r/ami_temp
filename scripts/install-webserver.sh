#!/bin/bash
apt-get update
apt-get install ruby-full ruby-webrick wget -y
REGION=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/[a-z]$//')

cd /home/ubuntu

#!/bin/bash
# start_docker.sh
cd /home/ec2-user/my-nginx-app
docker build -t my-nginx-image .
docker run -d --name my-nginx-container -p 80:80 my-nginx-image
#!/bin/bash
# start_docker.sh

cd /home/ec2-user/my-nginx-app

docker build -t my-nginx-image .

if docker ps -a | grep -q 'my-nginx-container'; then
    echo "Container 'my-nginx-container' already exists. Stopping and removing it."
    docker stop my-nginx-container
    docker rm my-nginx-container
fi

docker run -d --name my-nginx-container -p 80:80 my-nginx-image
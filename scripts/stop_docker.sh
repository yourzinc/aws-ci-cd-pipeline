#!/bin/bash
# stop_docker.sh
docker stop ${CONTAINER_NAME}
docker rm ${CONTAINER_NAME}
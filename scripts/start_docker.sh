#!/bin/bash
# start_docker.sh

IMAGE_NAME="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

$(aws ecr get-login --no-include-email --region ${AWS_REGION})

docker pull ${IMAGE_NAME}

if docker ps -a | grep -q "${CONTAINER_NAME}"; then
    echo "Container '${CONTAINER_NAME}' already exists. Stopping and removing it."
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
fi

docker run -d --name ${CONTAINER_NAME} -p 8080:8080 ${IMAGE_NAME}
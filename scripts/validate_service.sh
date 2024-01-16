#!/bin/bash
# validate_service.sh
if ! docker ps | grep -q my-nginx-container; then
    echo "Docker container is not running."
    exit 1
fi
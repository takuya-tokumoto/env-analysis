#!/bin/bash
IMAGE_NAME="env_analysis:ubuntu-22.04-base"
# docker build . -t ${IMAGE_NAME}
docker build -t ${IMAGE_NAME} -f ./Dockerfile.dev .

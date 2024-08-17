#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project-path> <docker-image>"
    exit 1
fi

SCRIPT_PATH=$(realpath $0)
SCRIPTS_PATH=$(dirname $SCRIPT_PATH)
LIBS_PATH=$(dirname $SCRIPT_PATH)/../libs
PROJECT_PATH=$(realpath "$1")
PROJECT_NAME=$(basename $PROJECT_PATH)
DOCKER_IMAGE=$2

# check if the project path is valid
if [ ! -d "$PROJECT_PATH" ]; then
    echo "Error: $PROJECT_PATH doesn't exist"
    exit 1
fi

# check if the docker image is valid
if [ -z "$(docker images -q $DOCKER_IMAGE)" ]; then
    echo "Error: $DOCKER_IMAGE is not a valid docker image"
    exit 1
fi

docker run -it --rm \
  -u $UID \
  -w /$PROJECT_NAME \
  --privileged \
  --device "/dev/bus/usb:/dev/bus/usb" \
  -v $PROJECT_PATH:/$PROJECT_NAME \
  -v $SCRIPTS_PATH:/scripts \
  -v $LIBS_PATH:/libs \
  $DOCKER_IMAGE bash

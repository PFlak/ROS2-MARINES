#!/bin/bash
# set -x

ROOT_DIR=$(pwd)
VERSION=_v0
argc=$#

# Assign docker image name
if [ $argc -eq 1 ] ; then
    docker_name=$1
    docker_name=${docker_name,,}
else
    docker_name=agh_marines_ros2$VERSION
fi

# Check if there is existing docker image
search_image=$(docker images | grep -c $docker_name)

if [ $search_image -eq 0 ]; then
    # No image found, creating new one
    echo "No image found, creating new one"
    docker image build -t $docker_name $ROOT_DIR
fi

# starts an image
echo "Starting image"
docker run -it \
    --user ros \
    --network=host \
    --ipc=host \
    --rm \
    -v $ROOT_DIR/src:/my_source_code \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /dev:/dev \
    --device-cgroup-rule='c *:* rmw' \
    --env=DISPLAY \
    -f
    $docker_name
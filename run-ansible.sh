#!/bin/bash

set -e

IMAGE_NAME="mminderbinder/ansible"
IMAGE_TAG="latest"
CONTAINER_NAME="ansible"
CONTAINER_NETWORK="docker1"
CONTAINER_IP="172.18.0.2"
PUBLISHED_IP=""

usage() {
	echo "Usage: ${0} <[run | stop]>"
	echo "${IMAGE_NAME} - Docker run script"
	exit 0
}

docker_run() {
	docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
	docker run \
		-it \
		--name "${CONTAINER_NAME}" \
		--network "${CONTAINER_NETWORK}" \
		--network-alias "${CONTAINER_NAME}" \
		--ip "${CONTAINER_IP}" \
        --volume "$(pwd)/srv:/srv/ansible" \
        --volume ~/.ssh/:/root/.ssh/:ro \
		"${IMAGE_NAME}:${IMAGE_TAG}" bash
}

docker_stop() {
	docker stop ${CONTAINER_NAME}
	docker rm ${CONTAINER_NAME}
}


if [[ -n "$1" ]]; then
	if [[ $1 == "-h" ]]; then
		usage
	elif [[ $1 == "run" ]]; then
		docker_run
	elif [[ $1 == "stop" ]]; then
		docker_stop
	else
		usage
	fi
else
	docker_run
fi



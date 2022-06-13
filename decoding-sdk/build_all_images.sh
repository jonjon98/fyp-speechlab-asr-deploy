#!/bin/bash

registry=ghcr.io/ntuspeechlab
version=1.0

echo Built images will be uploaded to $registry
docker build -t $registry/decoding-sdk:$version -f Dockerfile .

docker system prune -f


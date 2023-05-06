#!/bin/bash

IMAGE=klakegg/hugo:latest

docker pull $IMAGE

docker run --rm -it \
    -p 1313:1313  \
    -v $(pwd):/src \
    $IMAGE \
    server -D

#!/bin/bash

docker run -it --name tor-irssi -e TERM -u $(id -u):$(id -g) \
    --log-driver=none \
    -v $HOME/.irssi:/home/user/.irssi:rw \
    -v /etc/localtime:/etc/localtime:ro \
    splitstrikestream/arm64v8-alpine-tor-irssi

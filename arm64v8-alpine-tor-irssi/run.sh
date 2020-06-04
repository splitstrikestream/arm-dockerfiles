#!/bin/bash
set -e

_REL_DIRECTORY="`dirname \"$0\"`"
_ABS_DIRECTORY="`( cd \"$_REL_DIRECTORY\" && pwd )`"
_CURRDIR=$(pwd)

cd ${_ABS_DIRECTORY}


[ "$(docker images -q splitstrikestream/arm64v8-alpine-tor-irssi 2> /dev/null)" = "" ] && {
    echo "Docker image not found locally. Building it..."
    ./build.sh || {
        echo "Not possible to build image. Exiting..."
        exit 1
    }
    echo "Done!"
}

echo "Trying to remove previous container..."
docker rm tor-irssi || true

echo "Running tor-irssi container..."
docker run -it --name tor-irssi -e TERM -u $(id -u):$(id -g) \
    --log-driver=none \
    -v $HOME/.irssi:/home/user/.irssi:rw \
    -v /etc/localtime:/etc/localtime:ro \
    splitstrikestream/arm64v8-alpine-tor-irssi || true


cd ${_CURRDIR}

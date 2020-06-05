#!/bin/bash
set -e

_REL_DIRECTORY="`dirname \"$0\"`"
_ABS_DIRECTORY="`( cd \"$_REL_DIRECTORY\" && pwd )`"
_CURRDIR=$(pwd)


[ "$(docker images -q splitstrikestream/arm64v8-alpine-tor 2> /dev/null)" = "" ] && {
    echo "Docker image 'splitstrikestream/arm64v8-alpine-tor' not found locally. Trying to pull it..."
    docker pull splitstrikestream/arm64v8-alpine-tor 2> /dev/null || {
        echo "Docker image could not be pulled. Building it..."
        ${_ABS_DIRECTORY}/../arm64v8-alpine-tor/build.sh || {
            echo "Not possible to build image. Exiting..."
            exit 1
        }
    }
    echo "Done!"
}


cd ${_ABS_DIRECTORY}
docker build -t splitstrikestream/arm64v8-alpine-tor-irssi .
cd ${_CURRDIR}

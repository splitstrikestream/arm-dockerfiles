#!/bin/bash
set -e

_REL_DIRECTORY="`dirname \"$0\"`"
_ABS_DIRECTORY="`( cd \"$_REL_DIRECTORY\" && pwd )`"
_CURRDIR=$(pwd)

cd ${_ABS_DIRECTORY}
docker build -t splitstrikestream/arm64v8-alpine-tor .
cd ${_CURRDIR}

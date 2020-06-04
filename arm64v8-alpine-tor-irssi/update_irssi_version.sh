#!/bin/bash
set -eo pipefail

_REL_DIRECTORY="`dirname \"$0\"`"
_ABS_DIRECTORY="`( cd \"$_REL_DIRECTORY\" && pwd )`"
_CURRDIR=$(pwd)

cd ${_ABS_DIRECTORY}
current="$(git ls-remote --tags https://github.com/irssi/irssi.git | cut -d/ -f3 | cut -d^ -f1 | sort -uV | grep -vE -- '-rc|-git$|-dev$' | tail -1)"
set -x
sed -ri 's/^(ENV IRSSI_VERSION) .*/\1 '"$current"'/' Dockerfile
cd ${_CURRDIR}

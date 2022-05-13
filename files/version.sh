#!/usr/bin/env bash
  
set -e

PUPPET_GOGS_INSTALLATION_DIRECTORY=$1
PUPPET_GOGS_VERSION=$2

if [ ${PUPPET_GOGS_VERSION} == "latest" ]; then
    LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/gogits/gogs/releases/latest)
    LATEST_VERSION=$(echo ${LATEST_RELEASE} | sed -e 's/^.*"tag_name":"v\([^"]*\)".*$/\1/')
    PUPPET_GOGS_VERSION=${LATEST_VERSION}
fi

LOCAL_VERSION=$(${PUPPET_GOGS_INSTALLATION_DIRECTORY}/gogs --version 2>/dev/null| awk '{print $3}')

if [ ${LOCAL_VERSION} == ${PUPPET_GOGS_VERSION} ]; then
  exit 1
else
  exit 0
fi

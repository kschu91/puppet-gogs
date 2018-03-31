#!/usr/bin/env bash

set -e

if [ -z ${PUPPET_GOGS_INSTALLATION_DIRECTORY} ]; then echo "PUPPET_GOGS_INSTALLATION_DIRECTORY not set!"; exit 1;  fi
if [ -z ${PUPPET_GOGS_VERSION} ]; then echo "PUPPET_GOGS_VERSION not set!"; exit 1;  fi


if [ ${PUPPET_GOGS_VERSION} == "latest" ]; then
    LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/gogits/gogs/releases/latest)
    LATEST_VERSION=$(echo ${LATEST_RELEASE} | sed -e 's/^.*"tag_name":"v\([^"]*\)".*$/\1/')
    PUPPET_GOGS_VERSION=${LATEST_VERSION}
fi

DOWNLOAD_VERSION_URL="https://raw.githubusercontent.com/gogits/gogs/v${PUPPET_GOGS_VERSION}/templates/.VERSION"

if [ -f "${PUPPET_GOGS_INSTALLATION_DIRECTORY}/templates/.VERSION" ]; then

    LOCAL_VERSION=$(<"${PUPPET_GOGS_INSTALLATION_DIRECTORY}/templates/.VERSION")
    REMOTE_VERSION=$(wget -O- -q ${DOWNLOAD_VERSION_URL}) || exit 0

    if [ ${LOCAL_VERSION} == ${REMOTE_VERSION} ]; then
        #echo "${PUPPET_GOGS_VERSION} is already installed in ${PUPPET_GOGS_INSTALLATION_DIRECTORY}"
        exit 1
    fi
    #echo "${LOCAL_VERSION} is installed, ${REMOTE_VERSION} is available"
    exit 0
fi

exit 0
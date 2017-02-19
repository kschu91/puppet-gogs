#!/usr/bin/env bash

set -e

if [ -z ${PUPPET_GOGS_INSTALLATION_DIRECTORY} ]; then echo "PUPPET_GOGS_INSTALLATION_DIRECTORY not set!"; exit 1;  fi
if [ -z ${PUPPET_GOGS_OS} ]; then echo "PUPPET_GOGS_OS not set!"; exit 1;  fi
if [ -z ${PUPPET_GOGS_ARCH} ]; then echo "PUPPET_GOGS_ARCH not set!"; exit 1;  fi
if [ -z ${PUPPET_GOGS_VERSION} ]; then echo "PUPPET_GOGS_VERSION not set!"; exit 1;  fi

PUPPET_GOGS_ARCH=$(echo "${PUPPET_GOGS_ARCH}" | awk '{print tolower($0)}')
PUPPET_GOGS_OS=$(echo "${PUPPET_GOGS_OS}" | awk '{print tolower($0)}')

DOWNLOAD_TAR_GZ_URL="https://github.com/gogits/gogs/releases/download/v${PUPPET_GOGS_VERSION}/${PUPPET_GOGS_OS}_${PUPPET_GOGS_ARCH}.tar.gz"
DOWNLOAD_VERSION_URL="https://raw.githubusercontent.com/gogits/gogs/v${PUPPET_GOGS_VERSION}/templates/.VERSION"

if [ -f "${PUPPET_GOGS_INSTALLATION_DIRECTORY}/templates/.VERSION" ]; then

    LOCAL_VERSION=$(<"${PUPPET_GOGS_INSTALLATION_DIRECTORY}/templates/.VERSION")
    REMOTE_VERSION=$(wget -O- -q ${DOWNLOAD_VERSION_URL})

    if [ ${LOCAL_VERSION} == ${REMOTE_VERSION} ]; then
      echo "Version ${REMOTE_VERSION} already installed. skipping..."
      exit 0
    fi
fi

wget ${DOWNLOAD_TAR_GZ_URL} -O /tmp/gogs.tar.gz
tar -xzf /tmp/gogs.tar.gz -C ${PUPPET_GOGS_INSTALLATION_DIRECTORY} --strip 1
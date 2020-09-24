#!/usr/bin/env bash

set -e

if [ -z "${PUPPET_GOGS_INSTALLATION_DIRECTORY}" ]; then echo "PUPPET_GOGS_INSTALLATION_DIRECTORY not set!"; exit 1;  fi
if [ -z "${PUPPET_GOGS_OS}" ]; then echo "PUPPET_GOGS_OS not set!"; exit 1;  fi
if [ -z "${PUPPET_GOGS_ARCH}" ]; then echo "PUPPET_GOGS_ARCH not set!"; exit 1;  fi
if [ -z "${PUPPET_GOGS_VERSION}" ]; then echo "PUPPET_GOGS_VERSION not set!"; exit 1;  fi

PUPPET_GOGS_ARCH=$(echo "${PUPPET_GOGS_ARCH}" | awk '{print tolower($0)}')
PUPPET_GOGS_OS=$(echo "${PUPPET_GOGS_OS}" | awk '{print tolower($0)}')

PUPPET_GOGS_ARCH="${PUPPET_GOGS_ARCH/x86_64/amd64}"
PUPPET_GOGS_ARCH="${PUPPET_GOGS_ARCH/i386/386}"

if [ "${PUPPET_GOGS_VERSION}" == "latest" ]; then
    echo "fetching latest version"
    LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/gogits/gogs/releases/latest)
    # shellcheck disable=SC2001
    LATEST_VERSION=$(echo "${LATEST_RELEASE}" | sed -e 's/^.*"tag_name":"v\([^"]*\)".*$/\1/')
    echo "found latest version ${LATEST_VERSION}"
    PUPPET_GOGS_VERSION="${LATEST_VERSION}"
fi

DOWNLOAD_TAR_GZ_URL="https://github.com/gogits/gogs/releases/download/v${PUPPET_GOGS_VERSION}/${PUPPET_GOGS_OS}_${PUPPET_GOGS_ARCH}.tar.gz"
if curl --output /dev/null --location --silent --head --fail "${DOWNLOAD_TAR_GZ_URL}"; then
  echo "gogs download exists: ${DOWNLOAD_TAR_GZ_URL}"
else
  echo "gogs download does not exist: ${DOWNLOAD_TAR_GZ_URL}"
  DOWNLOAD_TAR_GZ_URL="https://github.com/gogits/gogs/releases/download/v${PUPPET_GOGS_VERSION}/gogs_${PUPPET_GOGS_VERSION}_${PUPPET_GOGS_OS}_${PUPPET_GOGS_ARCH}.tar.gz"
fi

echo "download and extract version ${PUPPET_GOGS_VERSION}"

wget "${DOWNLOAD_TAR_GZ_URL}" -O /tmp/gogs.tar.gz
tar -xzf /tmp/gogs.tar.gz -C "${PUPPET_GOGS_INSTALLATION_DIRECTORY}" --strip 1

rm -f /tmp/gogs.tar.gz
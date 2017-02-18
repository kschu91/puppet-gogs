#!/usr/bin/env bash

set -e

GO_INSTALLATION_DIR=$1
OS=$(echo "$2" | awk '{print tolower($0)}')
ARCH=$(echo "$3" | awk '{print tolower($0)}')
VERSION=$4

DOWNLOAD_TAR_GZ_URL="https://github.com/gogits/gogs/releases/download/v${VERSION}/${OS}_${ARCH}.tar.gz"

if [ -f "${GO_INSTALLATION_DIR}/templates/.VERSION" ]; then
    function semver_to_i() {
      spaced_current_version=`echo $1 | sed  "s/\./ /g"`
      printf "%.3d%.3d%.3d" ${spaced_current_version}
    }
    INSTALLED_VERSION=$(<"${GO_INSTALLATION_DIR}/templates/.VERSION")
    if [ `semver_to_i ${VERSION}` -le `semver_to_i ${INSTALLED_VERSION}` ]; then
      echo "already installed. skipping..."
      exit 0
    fi
fi

wget ${DOWNLOAD_TAR_GZ_URL} -O /tmp/gogs.tar.gz
tar -xzf /tmp/gogs.tar.gz -C ${GO_INSTALLATION_DIR} --strip 1
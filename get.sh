#!/bin/bash

##
# Usage: curl -sL https://raw.githubusercontent.com/NoUseFreak/ghget/master/get.sh | PROJECT=NoUseFreak/sawsh bash
##

# Variables
PROJECT=${PROJECT:-NoUseFreak/sawsh}
VERSION=${VERSION:-latest}
NAME=$(echo ${PROJECT##*/})
BIN_DIR=${BIN_DIR:-/usr/local/bin}
BIN_NAME=${BIN_NAME:-$NAME}
TMP_DIR=${TMP_DIR:-/tmp}

check_requirements() {
    local requirements=("curl" "tar" "uname" "sed")

    for cmd in "${requirements[@]}"
    do
        hash $cmd 2>/dev/null
        if [[ $? -ne 0 ]]
        then
            echo "ERROR: Could not find ${cmd}"
            exit 1
        fi
    done
}

get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" |
        grep '"tag_name":' |
        sed -E 's/.*"([^"]+)".*/\1/'
}

download() {
    downloadTar $1 2>/dev/null || downloadZip $1
}

downloadTar() {
    local url=https://github.com/${PROJECT}/releases/download/$1/`uname`_amd64.tar.gz
    local target=${TMP_DIR}/${NAME}.tar.gz
    curl -Ls --fail -o $target $url
}

downloadZip() {
    local url=https://github.com/${PROJECT}/releases/download/$1/`uname`_amd64.zip
    local target=${TMP_DIR}/${NAME}.zip
    curl -Ls --fail -o $target $url
}

extract() {
    rm -rf ${BIN_DIR}/${NAME}
    extractTar $1 2>/dev/null || extractZip $1
}

extractTar() {
    tar -xf ${TMP_DIR}/${NAME}.tar.gz -C ${BIN_DIR}/
}

extractZip() {
    unzip ${TMP_DIR}/${NAME} -d ${BIN_DIR}/
}

echo "Installing ${NAME} from ${PROJECT}"

echo " - Checking system requirements"
check_requirements

if [[ "${VERSION}" == "latest" ]]
then
    echo " - Looking up latest release"
    VERSION=$(get_latest_release $PROJECT)
fi
echo " - Installing version ${VERSION}"

echo " - Downloading package"
download ${VERSION}

echo " - Extract package"
extract

echo " - Making executable"
chmod +x ${BIN_DIR}/${BIN_NAME}

echo "Installed ${NAME} in ${BIN_DIR}/${BIN_NAME}"

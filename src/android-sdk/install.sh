#!/usr/bin/env bash

# Split by comma
IFS=',' read -ra SDK_COMPONENTS_ARRAY <<<"$SDKCOMPONENTS"
ANDROID_HOME=${ANDROIDHOME:-"/home/vscode/.android"}

set -e

add_dependencies() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        DEBIAN_FRONTEND="noninteractive" apt-get update -y && \
            apt-get -y install --no-install-recommends "$@"
    fi
}

setup_sdk_tools() {
    ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"

    wget -q "$ANDROID_SDK_URL" -O /tmp/cmdline-tools.zip
    unzip -oq /tmp/cmdline-tools.zip -d /tmp

    mkdir -p $ANDROID_HOME/cmdline-tools/latest
    mv /tmp/cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/ 2>/dev/null || true
}

install_sdk_components() {
    yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
        ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager "${SDK_COMPONENTS_ARRAY[@]}"
}

add_dependencies curl unzip xz-utils zip
setup_sdk_tools
install_sdk_components
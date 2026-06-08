#!/usr/bin/env bash

# Split by comma
IFS=',' read -ra SDK_COMPONENTS_ARRAY <<<"$SDKCOMPONENTS"
export ANDROID_HOME=${ANDROIDHOME:-"/home/vscode/.android"}
INSTALL_JDK=${INSTALLJDK}
JDK_VERSION=${JDKVERSION}
SDK_TOOLS_VERSION=${SDKTOOLSVERSION}

set -e

source ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer nanolayer_location "v0.5.6"

check_packages() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        DEBIAN_FRONTEND="noninteractive" apt-get update -y && \
            apt-get -y install --no-install-recommends "$@"
    fi
}

check_packages curl unzip xz-utils zip wget

# Setup SDK tools
ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip"

wget -q "$ANDROID_SDK_URL" -O /tmp/cmdline-tools.zip
unzip -oq /tmp/cmdline-tools.zip -d /tmp

mkdir -p $ANDROID_HOME/cmdline-tools/latest
mv /tmp/cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/ 2>/dev/null || true

# install SDK components
yes | "${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager" --licenses && \
        "${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager" "${SDK_COMPONENTS_ARRAY[@]}"

# Install JDK via java features
if [[ "${INSTALL_JDK}" = "true" ]] && ! /usr/local/sdkman/candidates/java/current/bin/java --version > /dev/null 2>&1; then
    $nanolayer_location \
        install \
        devcontainer-feature \
        "ghcr.io/devcontainers/features/java:1" \
        --option version="$JDK_VERSION"
fi

echo "Done!"

#!/bin/bash

set -e


# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# /home/vscode/.android/cmdline-tools/${SDK_TOOLS_VERSION}/bin/sdkmanager --list --verbose

check "sdkmanager installed" /home/vscode/.android/cmdline-tools/latest/bin/sdkmanager --version

# check if sdk components installed
check "adb installed" /home/vscode/.android/platform-tools/adb --version

# build-tools
check "apksigner installed" /home/vscode/.android/build-tools/33.0.0/apksigner version

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
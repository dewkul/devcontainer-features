#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

check "jdk installed" /usr/local/sdkman/candidates/java/current/bin/java --version

# cmd-tools
check "sdkmanager installed" /home/node/.android/cmdline-tools/latest/bin/sdkmanager --version

# platform-tools
# check "adb installed" /home/node/.android/platform-tools/adb --version

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
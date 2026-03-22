#!/bin/bash
set -e

WINE_VERSION=${VERSION:-"latest"}
WINE_BRANCH=${BRANCH}

get_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
    elif type lsb_release >/dev/null 2>&1; then
        ID=$(lsb_release -si)
        VERSION_ID=$(lsb_release -sr)
    fi
}

check_compatibility() {
    if [ $ID == "ubuntu" ] || [ $ID == "debian" ] ; then 
        package_manager="apt"
    elif [ $ID == "fedora" ] ; then
        package_manager="dnf"
    else
        echo "Linux distro ${ID} is not supported."
        exit 1
    fi
    echo "Using $package_manager as package manager"
}

add_wine_repo() {
    if [ $package_manager == "apt" ]; then
        sudo mkdir -pm755 /etc/apt/keyrings
        sudo wget --no-check-certificate -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -

        sudo dpkg --add-architecture i386
        sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/${ID}/dists/${UBUNTU_CODENAME:-$VERSION_CODENAME}/winehq-${UBUNTU_CODENAME:-$VERSION_CODENAME}.sources
    elif [ $package_manager == "yum" ]; then
        sudo dnf config-manager addrepo --from-repofile=https://dl.winehq.org/wine-builds/fedora/${VERSION_ID}/winehq.repo
    fi
}

pin_wine_version() {
    if [ $WINE_VERSION == "latest" ]; then
        echo "Set latest version of wine"
        return
    fi

    echo "Pinning wine version to $WINE_VERSION"

    if [ $package_manager == "apt" ]; then
        cat > /etc/apt/perferences.d/winehq.pref << EOF
Package: *wine* *wine*:i386
Pin: version $WINE_VERSION~*
Pin-Priority: 1001
EOF
    fi
}

install_wine() {
    echo "Installing winehq-$WINE_BRANCH"
    if [ $package_manager == "apt" ]; then
        export DEBIAN_FRONTEND=noninteractive

        apt-get update
        apt-get install --install-recommends -y winehq-$WINE_BRANCH
    fi
}

get_distro
check_compatibility
add_wine_repo
pin_wine_version
install_wine
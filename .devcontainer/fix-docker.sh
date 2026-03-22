#!/bin/bash

# docker-in-docker workaround - https://github.com/devcontainers/features/issues/977
if ! docker info > /dev/null 2>&1; then
    echo "Updating iptables for dind"
    sudo update-alternatives --set iptables /usr/sbin/iptables-nft
fi
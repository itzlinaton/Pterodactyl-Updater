#!/bin/bash

VERSION_FILE="/opt/Ptero-Updater/Version/install-script-version.txt"
REMOTE_VERSION_URL="https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/Version/install-script-version.txt"

if [ ! -f "$VERSION_FILE" ]; then
    exit 1
fi

LOCAL_VERSION=$(cat "$VERSION_FILE")
REMOTE_VERSION=$(curl -fsSL "$REMOTE_VERSION_URL")

if [ -z "$REMOTE_VERSION" ]; then
    exit 1
fi

if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
    echo "New version detected ($REMOTE_VERSION). Updating..."

    ptero-update-installer
fi

#!/bin/bash

VERSION_FILE="/opt/Ptero-Updater/Version/wings-panel-version.txt"

if [ ! -f "$VERSION_FILE" ]; then
    exit 1
fi

CURRENT_WINGS=$(grep "wings=" "$VERSION_FILE" | cut -d'=' -f2)
CURRENT_PANEL=$(grep "panel=" "$VERSION_FILE" | cut -d'=' -f2)

LATEST_WINGS=$(curl -fsSL https://api.github.com/repos/pterodactyl/wings/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')

LATEST_PANEL=$(curl -fsSL https://api.github.com/repos/pterodactyl/panel/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')

if [ -z "$LATEST_WINGS" ] || [ -z "$LATEST_PANEL" ]; then
    exit 1
fi

if [ "$CURRENT_WINGS" != "$LATEST_WINGS" ]; then
    echo "New Wings version detected: $LATEST_WINGS"
    ptero-update
    exit 0
fi

if [ "$CURRENT_PANEL" != "$LATEST_PANEL" ]; then
    echo "New Panel version detected: $LATEST_PANEL"
    ptero-update
    exit 0
fi
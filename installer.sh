#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

INSTALL_DIR="/opt/Ptero-Updater"
VERSION_DIR="$INSTALL_DIR/Version"

echo "Installing Pterodactyl Updater..."
echo ""

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run this installer as root user.${RESET}"
    exit 1
fi

# Create folder structure
mkdir -p "$VERSION_DIR"


# Install updater
curl -L -o "$INSTALL_DIR/ptero-update" \
"https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/Installation/ptero-update.sh"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to download updater.${RESET}"
    exit 1
fi

chmod +x "$INSTALL_DIR/ptero-update"

ln -sf "$INSTALL_DIR/ptero-update" /usr/local/bin/ptero-update


# Install installer updater
curl -L -o "$INSTALL_DIR/ptero-update-installer" \
"https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/Installation/ptero-update-installer.sh"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to download installer updater.${RESET}"
    exit 1
fi

chmod +x "$INSTALL_DIR/ptero-update-installer"

ln -sf "$INSTALL_DIR/ptero-update-installer" /usr/local/bin/ptero-update-installer


exec < /dev/tty


# Install version checker
echo ""
echo "Should the installer script automatically update itself?"
echo "Update checks are executed every 6 hours!"
echo ""

read -p "Enable automatic installer updates? (y/n): " AUTO_INSTALLER_UPDATE

if [[ "$AUTO_INSTALLER_UPDATE" =~ ^[Yy]$ ]]; then

    curl -L -o "$INSTALL_DIR/check-version" \
    "https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/Updaters/check-version.sh"

    chmod +x "$INSTALL_DIR/check-version"

    curl -L -o "$VERSION_DIR/version.txt" \
    "https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/Version/install-script-version.txt"

    echo "0 */6 * * * root $INSTALL_DIR/check-version >/dev/null 2>&1" > /etc/cron.d/ptero-updater-check

    echo "Automatic installer updates enabled."

else
    echo "Automatic installer updates disabled."
fi


# Install Wings/Panel checker
echo ""
echo "Should the installer script automatically update Panel and Wings?"
echo "Update checks are executed every 6 hours!"
echo ""

read -p "Enable automatic Panel & Wings updates? (y/n): " AUTO_PANEL_UPDATE

if [[ "$AUTO_PANEL_UPDATE" =~ ^[Yy]$ ]]; then

    curl -L -o "$INSTALL_DIR/check-wings-panel-version" \
    "https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/Updaters/check-wings-panel-version.sh"

    chmod +x "$INSTALL_DIR/check-wings-panel-version"

    curl -L -o "$VERSION_DIR/wings-panel-version.txt" \
    "https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/Version/wings-panel-version.txt"

    echo "0 */6 * * * root $INSTALL_DIR/check-wings-panel-version >/dev/null 2>&1" > /etc/cron.d/ptero-wings-panel-check

    echo "Automatic Panel & Wings updates enabled."

else
    echo "Automatic Panel & Wings updates disabled."
fi


echo ""
echo -e "${GREEN}"
echo "#################################################"
echo "#                                               #"
echo "#     PTERODACTYL UPDATER INSTALLED             #"
echo "#                                               #"
echo "#    You may now run: ptero-update              #"
echo "#    to update the panel and wings!             #"
echo "#                                               #"
echo "#    To update this installer script use:       #"
echo "#    ptero-update-installer                     #"
echo "#                                               #"
echo "#################################################"
echo -e "${RESET}"
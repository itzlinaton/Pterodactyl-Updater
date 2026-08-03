#!/bin/bash

#################################
# VERSION COMMAND
#################################

if [ "$1" = "--version" ]; then

    VERSION_FILE="/opt/Ptero-Updater/Version/install-script-version.txt"

    if [ -f "$VERSION_FILE" ]; then
        PTERO_UPDATER_VERSION=$(cat "$VERSION_FILE")
    else
        PTERO_UPDATER_VERSION="Unknown"
    fi

    echo "#################################################"
    echo "#                                               #"
    echo "#     PTERODACTYL PANEL UPDATER VERSION         #"
    echo "#                                               #"
    echo "#################################################"
    echo "Version: $PTERO_UPDATER_VERSION"

    exit 0
fi

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

clear

echo -e "${BLUE}"
echo "#################################################"
echo "#                                               #"
echo "#     PTERODACTYL PANEL & WINGS UPDATER         #"
echo "#                                               #"
echo "#################################################"
echo -e "${RESET}"

echo ""
echo -e "${CYAN}[INFO]${RESET} Starting update process..."
echo ""

#################################
# WINGS UPDATE
#################################

echo -e "${BLUE}"
echo "#################################################"
echo "#                 WINGS UPDATE                  #"
echo "#################################################"
echo -e "${RESET}"

LATEST_WINGS=$(curl -fsSL https://api.github.com/repos/pterodactyl/wings/releases/latest 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')
CURRENT_WINGS=$(wings version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -1)

if [ "$CURRENT_WINGS" = "$LATEST_WINGS" ]; then

    echo -e "${GREEN}[INFO]${RESET} Wings is already updated ($CURRENT_WINGS), skipping..."

else

    echo -e "${CYAN}[INFO]${RESET} Stopping Wings service..."
    systemctl stop wings

    echo -e "${CYAN}[INFO]${RESET} Downloading latest Wings version..."

    curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"

    echo -e "${CYAN}[INFO]${RESET} Applying permissions..."
    chmod u+x /usr/local/bin/wings

    echo -e "${CYAN}[INFO]${RESET} Restarting Wings service..."
    systemctl restart wings

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[SUCCESS]${RESET} Wings has been updated!"
    else
        echo -e "${RED}[ERROR]${RESET} Wings update failed. Stopping process."
        exit 1
    fi

fi

echo ""

#################################
# PANEL UPDATE
#################################

echo -e "${BLUE}"
echo "#################################################"
echo "#                 PANEL UPDATE                  #"
echo "#################################################"
echo -e "${RESET}"

LATEST_PANEL=$(curl -fsSL https://api.github.com/repos/pterodactyl/panel/releases/latest 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')
CURRENT_PANEL=$(grep "'version'" /var/www/pterodactyl/config/app.php | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -1)

if [ "$CURRENT_PANEL" = "$LATEST_PANEL" ]; then

    echo -e "${GREEN}[INFO]${RESET} Panel is already updated ($CURRENT_PANEL), skipping..."

else

    echo -e "${CYAN}[INFO]${RESET} Entering Pterodactyl directory..."

    cd /var/www/pterodactyl || exit 1

    echo -e "${CYAN}[INFO]${RESET} Enabling maintenance mode..."
    php artisan down

    echo -e "${CYAN}[INFO]${RESET} Downloading latest Panel files..."
    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

    echo -e "${CYAN}[INFO]${RESET} Updating permissions..."
    chmod -R 755 storage/* bootstrap/cache

    echo -e "${CYAN}[INFO]${RESET} Installing dependencies..."
    composer install --no-dev --optimize-autoloader

    echo -e "${CYAN}[INFO]${RESET} Clearing cache..."
    php artisan view:clear
    php artisan config:clear

    echo -e "${CYAN}[INFO]${RESET} Running database migrations..."
    php artisan migrate --seed --force

    echo -e "${CYAN}[INFO]${RESET} Fixing ownership..."
    chown -R www-data:www-data /var/www/pterodactyl/*

    echo -e "${CYAN}[INFO]${RESET} Restarting queue..."
    php artisan queue:restart

    echo -e "${CYAN}[INFO]${RESET} Disabling maintenance mode..."
    php artisan up

fi

if [ $? -eq 0 ]; then

    # Update installed versions
    VERSION_FILE="/opt/Ptero-Updater/Version/wings-panel-version.txt"

    if [ -n "$LATEST_WINGS" ] && [ -n "$LATEST_PANEL" ]; then
        mkdir -p /opt/Ptero-Updater/Version

        echo "wings=$LATEST_WINGS" > "$VERSION_FILE"
        echo "panel=$LATEST_PANEL" >> "$VERSION_FILE"
    fi

    echo ""
    echo -e "${GREEN}"
    echo "#################################################"
    echo "#                                               #"
    echo "#        PTERODACTYL UPDATE COMPLETE            #"
    echo "#                                               #"
    echo "#        PANEL AND WINGS ARE NOW UPDATED        #"
    echo "#                                               #"
    echo "#################################################"
    echo -e "${RESET}"

else
    echo -e "${RED}[ERROR]${RESET} Panel update failed."
    exit 1
fi

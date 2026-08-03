#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
RESET='\033[0m'

clear

echo -e "${BLUE}"
echo "#################################################"
echo "#                                               #"
echo "#      PTERODACTYL UPDATER INSTALLER            #"
echo "#                                               #"
echo "#      Updating installer script...             #"
echo "#                                               #"
echo "#################################################"
echo -e "${RESET}"

echo ""

echo -e "${BLUE}[INFO]${RESET} Downloading latest installer..."

curl -sSL https://raw.githubusercontent.com/itzlinaton/Pterodactyl-Updater/main/installer.sh | bash

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}"
    echo "#################################################"
    echo "#                                               #"
    echo "#        INSTALLER UPDATED SUCCESSFULLY         #"
    echo "#                                               #"
    echo "#     You may now use the latest installer.     #"
    echo "#                                               #"
    echo "#################################################"
    echo -e "${RESET}"
else
    echo ""
    echo -e "${RED}"
    echo "#################################################"
    echo "#                                               #"
    echo "#      INSTALLER UPDATE FAILED                  #"
    echo "#                                               #"
    echo "#################################################"
    echo -e "${RESET}"
    exit 1
fi

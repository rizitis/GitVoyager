##!/bin/bash


if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}GitVoyager should do not installed or uninstalled as root${NC}"
    echo -e "Exiting..."
    exit 1
fi

# Exit on error
set -e
INST_DIR="$HOME/GitVoyager/"
# Perform uninstallation
rm -fr "$INST_DIR"

# Display uninstallation completion message
echo "GitVoyager has been successfully uninstalled."

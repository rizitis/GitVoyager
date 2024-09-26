##!/bin/bash


set -e

if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}GitVoyager should not installed as root${NC}"
    echo -e "Exiting..."
    exit 1
fi

# Get the current directory name
CURRENT_DIR=$(basename "$PWD")

# Change to the parent directory
cd "$(pwd)/.."

# Move the original directory to $HOME
rm -fr "$CURRENT_DIR" gitv

# Display uninstallation completion message
echo "GitVoyager has been successfully uninstalled."

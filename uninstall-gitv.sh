#!/bin/bash

# Exit on any error
set -e

# Define colors for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if the script is being run as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: GitVoyager should not be uninstalled as root.${NC}"
    echo "Please rerun the script as a non-root user."
    exit 1
fi

# Capture the name of the current directory
CURRENT_DIR=$(basename "$PWD")

# Navigate to the parent directory
cd ..

# List of files/directories to remove
to_remove=("$CURRENT_DIR" "gitv")

# Loop through each item and attempt to delete it
for item in "${to_remove[@]}"; do
    if [ -e "$item" ]; then
        rm -fr "$item"
        echo -e "${GREEN}Deleted: $item${NC}"
    else
        echo -e "${RED}Warning: $item not found. Skipping deletion.${NC}"
    fi
done

# Display a confirmation message upon successful uninstallation
echo -e "${GREEN}GitVoyager has been successfully uninstalled from your system.${NC}"


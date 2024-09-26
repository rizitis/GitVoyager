#!/bin/bash
# Exit on any error
set -e

# Define colors for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if the script is being run as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: GitVoyager should not be installed as root.${NC}"
    echo "Exiting..."
    exit 1
fi

# Get the current directory name
CURRENT_DIR=$(basename "$PWD")

# Define installation path
INSTALL_PATH="$HOME/.local/bin/GitVoyager"
GITV_PATH="$HOME/.local/bin/gitv"

# Check if an old installation exists
if [ -d "$INSTALL_PATH" ]; then
    echo -e "${RED}Warning: An existing installation of GitVoyager was found at $INSTALL_PATH.${NC}"
    read -p "Would you like to (r)emove it or (q)uit it? (r/q): " action
    if [[ "$action" == "r" ]]; then
        echo -e "${GREEN}Removing old installation...${NC}"
        rm -rf "$INSTALL_PATH"
        echo -e "${GREEN}Old installation removed.${NC}"
    elif [[ "$action" == "q" ]]; then
        echo -e "${GREEN}Quit installation...${NC}"
        exit 0
    else
        echo -e "${RED}Invalid option. Exiting installation.${NC}"
        exit 1
    fi
fi

# Check if gitv already exists
if [ -f "$GITV_PATH" ]; then
    echo -e "${RED}Warning: An existing 'gitv' executable was found at $GITV_PATH.${NC}"
    read -p "Would you like to (r)epace it, (b)ackup it, or (k)eep it? (r/b/k): " action
    if [[ "$action" == "r" ]]; then
        echo -e "${GREEN}Replacing existing 'gitv' executable...${NC}"
        rm "$GITV_PATH"
    elif [[ "$action" == "b" ]]; then
        echo -e "${GREEN}Backing up existing 'gitv' executable...${NC}"
        mv "$GITV_PATH" "$GITV_PATH.bak"
        echo -e "${GREEN}Backup created at $GITV_PATH.bak.${NC}"
    elif [[ "$action" == "k" ]]; then
        echo -e "${GREEN}Keeping existing 'gitv' executable.${NC}"
    else
        echo -e "${RED}Invalid option. Exiting installation.${NC}"
        exit 1
    fi
fi

# Make necessary scripts executable
chmod +x gitv get-voyager.sh fetch-voyager.sh uninstall-gitv.sh
echo -e "${GREEN}Made scripts executable.${NC}"

# Change to the parent directory
cd "$(pwd)/.."

# Move the original directory to $HOME
if mv "$CURRENT_DIR" "$INSTALL_PATH"; then
    echo -e "${GREEN}Moved $CURRENT_DIR to $INSTALL_PATH.${NC}"
else
    echo -e "${RED}Error: Failed to move $CURRENT_DIR to $INSTALL_PATH.${NC}"
    exit 1
fi

# Copy the main executable to the local bin directory
if cp "$INSTALL_PATH/gitv" "$HOME/.local/bin/"; then
    echo -e "${GREEN}Copied gitv to $HOME/.local/bin/${NC}"
else
    echo -e "${RED}Error: Failed to copy gitv to $HOME/.local/bin.${NC}"
    exit 1
fi

# Display ASCII art banner
cat << 'EOF'

   _____ _ ___      __
  / ____(_) \ \    / /
 | |  __ _| |\ \  / /__  _   _  __ _  __ _  ___ _ __
 | | |_ | | __\ \/ / _ \| | | |/ _` |/ _` |/ _ \ '__|
 | |__| | | |_ \  / (_) | |_| | (_| | (_| |  __/ |
  \_____|_|\__| \/ \___/ \__, |\__,_|\__, |\___|_|
                          __/ |       __/ |
                         |___/       |___/

EOF

# Final success message
echo ""
echo -e "${GREEN}GitVoyager has been successfully installed.${NC}"
echo -e "Installation Directory: $INSTALL_PATH"
echo -e "To get started, use the command: gitv help"
echo -e "README: https://github.com/rizitis/GitVoyager/blob/main/README.md"


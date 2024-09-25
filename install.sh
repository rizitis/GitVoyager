#!/bin/bash

# Navigate to the directory of the script and set current working directory
cd $(dirname $0) || exit
CWD=$(pwd)

if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}GitVoyager should do not installed as root${NC}"
    echo -e "Exiting..."
    exit 1
fi

# Exit on error
set -e
INST_DIR="$HOME/GitVoyager/"
mkdir -p "$INST_DIR"
# Copy configuration file to /etc
if cp "$CWD/gitv.conf" "$INST_DIR"; then
    echo "Configuration file copied to /etc."
else
    echo "Error: Failed to copy configuration file."
    exit 1
fi

# Create directory for GitVoyager in /usr/local/bin/ and copy necessary files
if mkdir -p ""$INST_DIR"" && cp "$CWD"/{gitv,get-voyager.sh,fetch-voyager.sh,uninstall-gitv.sh} ""$INST_DIR""; then
    echo "GitVoyager files copied to "$INST_DIR""
else
    echo "Error: Failed to copy GitVoyager files."
    exit 1
fi

# Set permissions for all files in the GitVoyager directory
if chmod 777 ""$INST_DIR""{gitv,get-voyager.sh,fetch-voyager.sh,uninstall-gitv.sh}; then
    echo "Permissions set for GitVoyager files."
else
    echo "Error: Failed to set file permissions."
    exit 1
fi

# Display ASCII art banner and installation success message
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
echo -e "GitVoyager has been successfully installed."
echo -e "To get started, use the command: gitv help"
echo ""

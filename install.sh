#!/bin/bash

# Navigate to the directory of the script and set current working directory
cd $(dirname $0) || exit
CWD=$(pwd)

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Permission Denied"
    echo "This operation requires root privileges. Please run this script as root."
    exit 1
fi

# Exit on error
set -e

# Copy configuration file to /etc
if cp "$CWD/gitv.conf" /etc/; then
    echo "Configuration file copied to /etc."
else
    echo "Error: Failed to copy configuration file."
    exit 1
fi

# Create directory for GitVoyager in /opt and copy necessary files
if mkdir -p /usr/local/bin/GitVoyager && cp "$CWD"/{gitv,get-voyager.sh,fetch-voyager.sh,uninstall-gitv.sh} /opt/GitVoyager/; then
    echo "GitVoyager files copied to /opt/GitVoyager."
else
    echo "Error: Failed to copy GitVoyager files."
    exit 1
fi

# Set permissions for all files in the GitVoyager directory
if chmod 777 /usr/local/bin/GitVoyager/*; then
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

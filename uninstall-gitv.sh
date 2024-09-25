##!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Permission Denied"
    echo "This operation requires root privileges. Please run this script as root:"
    echo "sudo /opt/GitVoyager/uninstall-gitv.sh"
    exit 1
fi

# Exit on error
set -e

# Perform uninstallation
rm /etc/gitv.conf
rm -fr /opt/GitVoyager

# Display uninstallation completion message
echo "GitVoyager has been successfully uninstalled."

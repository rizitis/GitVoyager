#!/bin/bash
set -e

if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}GitVoyager should not installed as root${NC}"
    echo -e "Exiting..."
    exit 1
fi

# Get the current directory name
CURRENT_DIR=$(basename "$PWD")
chmod +x gitv get-voyager.sh fetch-voyager.sh uninstall-gitv.sh

# Change to the parent directory
cd "$(pwd)/.."

# Move the original directory to $HOME
mv "$CURRENT_DIR" "$HOME"/.local/bin/GitVoyager
cp "$HOME"/.local/bin/GitVoyager/gitv "$HOME"/.local/bin/
echo "$CURRENT_DIR has been moved to "$HOME"/.local/bin"

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
echo -e "$HOME/.local/bin/$CURRENT_DIR"
echo -e "To get started, use the command: gitv help"

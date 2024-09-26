#!/bin/bash

# Specify the name of the JSON file containing the repo contents
INPUT_JSON="./repo_contents.json"

# Get the specific file or directory name from the command line argument
SPECIFIC_PATH="$1"

# Function to read token from specified file
read_token() {
    if [ -f "$TOKEN_FILE_PATH" ]; then
        TOKEN=$(cat "$TOKEN_FILE_PATH")
        if [ -z "$TOKEN" ]; then
            echo "Token file is empty. Proceeding without token."
            TOKEN=""
        else
            echo "Token read successfully."
        fi
    else
        echo "Token file not found. Proceeding without token."
        TOKEN=""
    fi
}

# Function to download a file from GitHub using the token
download_file() {
    local file_path="$1"
    local target_path="$2"

    echo "Downloading file: $file_path to $target_path"
    FILE_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/$file_path"

    if [ -n "$TOKEN" ]; then
        curl -H "Authorization: token $TOKEN" -L -o "$target_path" "$FILE_URL"
    else
        curl -L -o "$target_path" "$FILE_URL"
    fi
}

# Function to download all files in a directory and create the directory structure
download_directory() {
    local dir_path="$1"
    echo "Downloading contents of directory: $dir_path"

    # Create the directory locally
    mkdir -p "$dir_path"

    # Find all items in the specified directory
    jq -c --arg dir_path "$dir_path" '.[] | select(.path | startswith($dir_path + "/"))' "$INPUT_JSON" | while read -r item; do
        echo "Processing item: $item"  # Log the item being processed

        # Parse item JSON into separate variables
        local item_name=$(echo "$item" | jq -r '.name')
        local item_path=$(echo "$item" | jq -r '.path')
        local item_type=$(echo "$item" | jq -r '.type')

        # Check the type of the item
        if [ "$item_type" == "file" ]; then
            # Download the file into the local directory
            download_file "$item_path" "$dir_path/$item_name"
        elif [ "$item_type" == "dir" ]; then
            echo "Creating directory: $dir_path/$item_name"
            download_directory "$item_path"  # Recurse into the subdirectory
        else
            echo "Unknown item type: $item_type"
        fi
    done
}

# Function to download the specific file or directory from the JSON
download_specific_path() {
    echo "Downloading the specific path: $SPECIFIC_PATH"

    # Check if the path exists in the JSON
    local path_info=$(jq -r --arg path "$SPECIFIC_PATH" '.[] | select(.path == $path)' "$INPUT_JSON")

    # Ensure path_info is not empty
    if [ -z "$path_info" ]; then
        echo "Path '$SPECIFIC_PATH' not found in the JSON."
        exit 1
    fi

    # Print debug info about the path_info to check its structure
    echo "Path info: $path_info"

    # Determine the item type
    local item_type=$(echo "$path_info" | jq -r '.type')

    if [ "$item_type" == "file" ]; then
        local file_path=$(echo "$path_info" | jq -r '.path')
        download_file "$file_path" "$SPECIFIC_PATH"  # Save file in the current directory
    elif [ "$item_type" == "dir" ]; then
        download_directory "$SPECIFIC_PATH"
    else
        echo "Unknown item type: $item_type"
        exit 1
    fi
}

# Main script
if [ -z "$SPECIFIC_PATH" ]; then
    echo "Please provide a specific file or directory to download."
    exit 1
fi

read_token

# Download the specific file or directory
download_specific_path

echo "Download finished."

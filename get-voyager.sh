#!/bin/bash
. "$HOME"/.local/bin/GitVoyager/gitv.conf
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

download_file() {
    local file_path="$1"
    local target_path="$2"

    echo "Downloading file: $file_path to $target_path"
    FILE_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/$file_path"
    echo "Constructed URL: $FILE_URL"  # Debugging line

    if [ -n "$TOKEN" ]; then
        curl -H "Authorization: token $TOKEN" -L -o "$target_path" "$FILE_URL"
    else
        curl -L -o "$target_path" "$FILE_URL"
    fi

    # Check if the download was successful
    if [ $? -ne 0 ]; then
        echo "Error downloading file from URL: $FILE_URL"
    fi
}

download_directory() {
    local dir_path="$1"
    echo "Downloading contents of directory: $dir_path"

    # Create the directory locally
    mkdir -p "$dir_path"

    # Find all items in the JSON where the path starts with the requested directory
    local items=$(jq -c --arg dir_path "$dir_path" '.[] | select(.path | startswith($dir_path + "/"))' "$INPUT_JSON")

    if [ -z "$items" ]; then
        echo "Directory $dir_path is empty or not found in JSON."
        return
    fi

    # Iterate over the items and process them
    echo "$items" | while read -r item; do
        echo "Processing item: $item"

        # Parse item JSON into separate variables
        local item_name=$(echo "$item" | jq -r '.name')
        local item_path=$(echo "$item" | jq -r '.path')
        local item_type=$(echo "$item" | jq -r '.type')

        # Skip processing if the item is the current directory itself
        if [ "$item_path" == "$dir_path" ]; then
            continue
        fi

        # Check the item type and handle files and directories accordingly
        if [ "$item_type" == "file" ]; then
            # Handle nested files by creating the correct directory structure
            local relative_path="${item_path#$dir_path/}"
            local target_file="$dir_path/$relative_path"
            mkdir -p "$(dirname "$target_file")"
            download_file "$item_path" "$target_file"
        elif [ "$item_type" == "dir" ]; then
            # Recurse into subdirectories
            download_directory "$item_path"
        else
            echo "Unknown item type: $item_type"
        fi
    done
}


download_specific_path() {
    echo "Downloading the specific path: $SPECIFIC_PATH"

    # First check the exact path
    local path_info=$(jq -r --arg path "$SPECIFIC_PATH" '.[] | select(.path == $path)' "$INPUT_JSON")

    if [ -z "$path_info" ]; then
        # If not found, try to search for the exact match within the correct directory structure
        local adjusted_path="builds/$SPECIFIC_PATH"
        path_info=$(jq -r --arg path "$adjusted_path" '.[] | select(.path == $path)' "$INPUT_JSON")

        if [ -z "$path_info" ]; then
            # If still not found, try to search by just the filename in the entire JSON
            local filename=$(basename "$SPECIFIC_PATH")
            path_info=$(jq -r --arg filename "$filename" '.[] | select(.name == $filename)' "$INPUT_JSON")
            echo "Trying to find file by name: $filename"
        fi
    fi

    echo "Path info: $path_info"

    if [ -z "$path_info" ]; then
        echo "Path '$SPECIFIC_PATH' not found in the JSON."
        exit 1
    fi

    # Determine item type and download
    local item_type=$(echo "$path_info" | jq -r '.type')

    if [ "$item_type" == "file" ]; then
        # Get the full path for the file
        local full_file_path=$(echo "$path_info" | jq -r '.path')
        download_file "$full_file_path" "$SPECIFIC_PATH"
    elif [ "$item_type" == "dir" ]; then
        # If it's a directory, download the directory
        local full_dir_path=$(echo "$path_info" | jq -r '.path')
        download_directory "$full_dir_path"
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


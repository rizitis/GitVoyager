#!/bin/bash


OUTPUT_JSON="repo_contents.json"  # Name of the output JSON file

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

# Function to fetch contents of a directory recursively and save to JSON
fetch_contents_recursively() {
    local path="$1"
    local contents=$(curl -s -H "Authorization: token $TOKEN" "$GITHUB_API/$REPO_OWNER/$REPO_NAME/contents/$path?ref=$BRANCH")

    if [ $? -ne 0 ]; then
        echo "Failed to fetch contents for $path"
        return 1
    fi

    # Process each item and construct JSON
    while IFS= read -r item; do
        local name=$(echo "$item" | jq -r '.name')
        local item_path=$(echo "$item" | jq -r '.path')
        local item_type=$(echo "$item" | jq -r '.type')

        # Append to JSON output
        echo "{\"name\": \"$name\", \"path\": \"$item_path\", \"type\": \"$item_type\"}," >> "$OUTPUT_JSON"

        # If the item is a directory, fetch its contents recursively
        if [[ $item_type == "dir" ]]; then
            fetch_contents_recursively "$item_path"
        fi
    done < <(echo "$contents" | jq -c '.[]')
}

# Main script
read_token

# Initialize or clear the output JSON file
if [ -f "$OUTPUT_JSON" ]; then
    # Clear the existing contents
    > "$OUTPUT_JSON"
else
    # Create the file if it doesn't exist
    touch "$OUTPUT_JSON"
fi

# Start the JSON array
echo "[" > "$OUTPUT_JSON"

# Fetch the contents recursively starting from the root
fetch_contents_recursively ""

# Remove the last comma before closing the JSON array
sed -i '$ s/,$//' "$OUTPUT_JSON"

# Close the JSON array
echo "]" >> "$OUTPUT_JSON"

echo "Repository contents saved to $OUTPUT_JSON."


#!/usr/bin/env bash

# Script to import a parsed JSON file to Sync Gateway
# format [{key:value, key:value}, {key:value, key:value}]
# id is created by this script
# ensure that jq is installed and in PATH

# Ensure a filename is provided as an argument
if [[ -z "$1" ]]; then
    echo "Usage: $0 <path-to-json-file>"
    exit 1
fi

# Path to your JSON file
JSON_FILE="$1"

# Sync Gateway endpoint. Modify this accordingly.
SG_ENDPOINT="http://localhost:4984/buecherteam/"

# Check if the JSON file exists
if [[ ! -f "$JSON_FILE" ]]; then
    echo "Error: File $JSON_FILE not found!"
    exit 1
fi

# Import each document in the JSON file to Sync Gateway
cat "$JSON_FILE" | jq -c '.[]' | while read -r doc; do
    response=$(curl -s -X POST "$SG_ENDPOINT" -H 'Authorization: Basic ZGliYm86ZGliYm9NcmlubW95' -H "accept: application/json" -H "Content-Type: application/json" -d "$doc")

    # Print the response to see the result (e.g., if the document was added successfully)
    echo "$response"
done

# Finish
echo "Import process completed."


#!/bin/bash

# -----------------------------------------------------------------------------
# Script Name: list_tgz_contents.sh
# Description: Finds all .tgz files in a given directory (including subdirectories),
#              lists their internal file structures, and saves the output to a file.
# Usage:       ./list_tgz_contents.sh /path/to/input_directory /path/to/output_file
# -----------------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage information
usage() {
    echo "Usage: $0 INPUT_DIRECTORY OUTPUT_FILE"
    echo "Example: $0 /home/user/tgz_files /home/user/tgz_contents.txt"
    exit 1
}

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Error: Invalid number of arguments."
    usage
fi

# Assign input arguments to variables
INPUT_DIR="$1"
OUTPUT_FILE="$2"

# Verify that the input directory exists and is a directory
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist or is not a directory."
    exit 1
fi

# Create or empty the output file
> "$OUTPUT_FILE"

# Find all .tgz files and process them
find "$INPUT_DIR" -type f -name "*.tgz" -print0 | while IFS= read -r -d '' TGZ_FILE
do
    echo "Processing: $TGZ_FILE" | tee -a "$OUTPUT_FILE"
    echo "Contents of $TGZ_FILE:" >> "$OUTPUT_FILE"

    # List the contents of the .tgz file
    if tar -tzf "$TGZ_FILE" >> "$OUTPUT_FILE" 2>/dev/null; then
        echo "Successfully listed contents of $TGZ_FILE." | tee -a "$OUTPUT_FILE"
    else
        echo "Error: Failed to list contents of $TGZ_FILE." | tee -a "$OUTPUT_FILE" >&2
    fi

    echo -e "\n----------------------------------------\n" >> "$OUTPUT_FILE"
done

echo "All .tgz file structures have been saved to '$OUTPUT_FILE'."

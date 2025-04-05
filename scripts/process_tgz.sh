#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage information
usage() {
    echo "Usage: $0 <input_directory> <output_directory> <output_file>"
    exit 1
}

# Check if exactly three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Error: Invalid number of arguments."
    usage
fi

# Assign arguments to variables for better readability
INPUT_DIR="$1"
OUTPUT_DIR="$2"
OUTPUT_FILE="$3"

# Check if input directory exists and is a directory
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist or is not a directory."
    exit 1
fi

# Check if output directory exists and is a directory
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Output directory '$OUTPUT_DIR' does not exist or is not a directory."
    exit 1
fi

# Ensure the output file is writable (create it if it doesn't exist)
touch "$OUTPUT_FILE" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Error: Cannot write to output file '$OUTPUT_FILE'."
    exit 1
fi

# Initialize or clear the output file
> "$OUTPUT_FILE"

# Find all .tgz files in the input directory and its subdirectories
find "$INPUT_DIR" -type f -name "*.tgz" | while read -r TGZ_FILE; do
    # Extract the base name without the directory and extension
    BASE_NAME=$(basename "$TGZ_FILE" .tgz)

    # Define the expected .npy file path in the output directory
    NPY_FILE="${OUTPUT_DIR}/${BASE_NAME}.npy"

    # Check if the .npy file exists
    if [ ! -f "$NPY_FILE" ]; then
        # If not, append the .tgz file path to the output file
        echo "$TGZ_FILE" >> "$OUTPUT_FILE"
    fi
done

echo "Processing complete. Check '$OUTPUT_FILE' for the list of .tgz files."

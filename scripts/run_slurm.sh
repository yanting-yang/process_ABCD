#!/bin/bash

INPUT_DIR="$HOME/datasets/ABCD"
OUTPUT_DIR="$HOME/datasets/ABCD_DiFuMo1024"

# Initialize an index counter
index=0
array=""

# Find all .tgz files in the input directory and its subdirectories
files=$(find "$INPUT_DIR" -type f -name "*.tgz")
for file in $files; do
    # Extract the base filename without extension and path
    base_name=$(basename "$file" .tgz)

    # Define the expected .npy filename in the output directory
    npy_file="$OUTPUT_DIR/${base_name}.npy"
    # Check if the .npy file exists
    if [ -f "$npy_file" ]; then
        # .npy file exists, skip this .tgz file
        continue
    else
        # .npy file does not exist, output the index and the .tgz file path separated by a comma
        array+="$index,"
    fi
    index=$((index + 1))
done

array=${array%,}

sbatch \
    --array=$array \
    ./scripts/slurm.sh

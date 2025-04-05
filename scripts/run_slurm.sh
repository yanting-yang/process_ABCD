#!/bin/bash

INPUT_DIR="$HOME/datasets/ABCD"
OUTPUT_DIR="$HOME/datasets/ABCD_DiFuMo1024"

index=0
array=()

files=$(find "$INPUT_DIR" -type f -name "*.tgz")
for file in $files; do
    base_name="${file##*/}"
    base_name="${base_name%.tgz}"
    npy_file="$OUTPUT_DIR/${base_name}.npy"
    if [ -f "$npy_file" ]; then
        echo "File $npy_file already exists, skipping."
    else
        array+=("$index")
        echo "File $file does not exist, adding to array index $index"
    fi
    ((index++))
done

array_str=$(IFS=, ; echo "${array[*]}")

sbatch \
    --array=$array \
    ./scripts/slurm.sh

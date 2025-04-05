#!/bin/bash

INPUT_DIR="$HOME/datasets/ABCD"
OUTPUT_DIR="$HOME/datasets/ABCD_DiFuMo1024"

NUM_FILE=$(find "$INPUT_DIR" -type f -name "*.tgz" | wc -l)

sbatch \
    --array=1-$NUM_FILE \
    ./scripts/slurm.sh

#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=12G
#SBATCH -o log/%a.out
#SBATCH -e log/%a.err

module load apptainer/1.3.5

INPUT_DIR="$HOME/datasets/ABCD"
OUTPUT_DIR="$HOME/datasets/ABCD_DiFuMo1024"

FILE_LIST=($(find "$INPUT_DIR" -type f -name "*.tgz"))
FILE_TO_PROCESS=${FILE_LIST[$SLURM_ARRAY_TASK_ID]}
echo $FILE_TO_PROCESS
apptainer run --cleanenv process_abcd.simg \
    python main.py \
        -p "$FILE_TO_PROCESS" \
        -m ./difumo1024.nii.gz \
        -s "$OUTPUT_DIR"

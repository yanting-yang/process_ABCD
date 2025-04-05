import json
from pathlib import Path
import tarfile
import tempfile
import argparse

import nibabel as nib
from nilearn.maskers import NiftiMapsMasker
import numpy as np


def process_rsfMRI(p: str, maps_img_path: str, save_dir: str):
    """
    Processes rsfMRI data from a compressed archive.

    Parameters:
    - p (str): Path to the input tar.gz archive containing rsfMRI data.
    - maps_img_path (str): Path to the NIfTI maps image (e.g., difumo64.nii.gz).
    - save_dir (str): Directory where the output .npy files will be saved.
    """
    maps_img = nib.load(maps_img_path)
    save_dir = Path(save_dir)
    # Ensure the save directory exists
    save_dir.mkdir(parents=True, exist_ok=True)

    with (
        tarfile.open(p, 'r:gz') as tar,
        tempfile.TemporaryDirectory() as temp_dir
    ):
        # Extract all members to a temporary directory
        tar.extractall(path=temp_dir)
        temp_path = Path(temp_dir)
        nii_files = list(temp_path.glob('**/*.nii'))
        json_files = list(temp_path.glob('**/*bold.json'))
        confounds = list(temp_path.glob('**/*motion.tsv'))

        if not nii_files:
            raise FileNotFoundError(
                'No NIfTI (.nii) files found in the archive.'
            )
        if not json_files:
            raise FileNotFoundError(
                'No JSON (.json) files found in the archive.'
            )
        if not confounds:
            raise FileNotFoundError(
                'No confounds (.tsv) files found in the archive.'
            )

        nii_file = nii_files[0]
        json_file = json_files[0]
        name = Path(p).stem

        # Read the JSON file
        with open(json_file) as f:
            json_data = json.load(f)
        t_r = json_data.get('RepetitionTime')

        if t_r is None:
            raise KeyError("'RepetitionTime' not found in the JSON file.")

        img = nib.load(nii_file)

        masker = NiftiMapsMasker(
            maps_img=maps_img,
            standardize='zscore_sample',
            detrend=True,
            t_r=t_r,
            dtype=np.float32,
            verbose=1
        )

        img_masked = masker.fit_transform(img, confounds)
        output_path = save_dir / f'{name}.npy'
        np.save(output_path, img_masked)
        print(f'Saved masked image to {output_path}')


def main():
    parser = argparse.ArgumentParser(
        description='Process rsfMRI data from a tar.gz archive.'
    )
    parser.add_argument(
        '-p', '--path',
        type=str,
        required=True,
        help='Path to the tar.gz archive containing rsfMRI data.'
    )
    parser.add_argument(
        '-m', '--maps_img',
        type=str,
        required=True,
        help='Path to the NIfTI maps image (e.g., difumo64.nii.gz).'
    )
    parser.add_argument(
        '-s', '--save_dir',
        type=str,
        required=True,
        help='Directory where the output .npy files will be saved.'
    )

    args = parser.parse_args()

    process_rsfMRI(args.path, args.maps_img, args.save_dir)


if __name__ == '__main__':
    main()

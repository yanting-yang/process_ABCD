# README

Copy one data file for testing:

```bash
rsync -avP cedar:~/datasets/ABCD/fmriresults01/abcd-mproc-release5/NDARINV6G63TU7R_baselineYear1Arm1_ABCD-MPROC-rsfMRI_20180427114950.tgz ./
```

List tgz contents:

```bash
./scripts/list_tgz_contents.sh ~/datasets/ABCD ./list_tgz_contents.out
```

Test `main.py`:

```bash
python main.py \
    -p ./NDARINV6G63TU7R_baselineYear1Arm1_ABCD-MPROC-rsfMRI_20180427114950.tgz \
    -m ./difumo64.nii.gz \
    -s ./
```

Test `process_tgz.sh`:

```bash
./scripts/process_tgz.sh ./ ./ process_tgz.out
```

Run `process_tgz.sh`:

```bash
./scripts/process_tgz.sh ~/datasets/ABCD ~/datasets/ABCD_DiFuMo1024 process_tgz.out
```

Build Docker image:

```bash
docker build -t ghcr.io/yanting-yang/process_abcd:latest .
```

Test Apptainer image:

```bash
apptainer build process_abcd.simg docker-daemon://ghcr.io/yanting-yang/process_abcd:latest
apptainer run --cleanenv process_abcd.simg \
    python main.py \
        -p ./NDARINV6G63TU7R_baselineYear1Arm1_ABCD-MPROC-rsfMRI_20180427114950.tgz \
        -m ./difumo64.nii.gz \
        -s ./
```

Push Docker image:

```bash
echo $GH_TOKEN | docker login ghcr.io -u yanting-yang --password-stdin
docker push ghcr.io/yanting-yang/process_abcd:latest
```

Build Apptainer image:

```bash
apptainer build process_abcd.simg docker://ghcr.io/yanting-yang/process_abcd:latest
```

Test `run_slurm.sh`:

```bash
./scripts/run_slurm.sh ./ ./
./scripts/slurm.sh
```

# README

Copy one data file for testing:

```bash
rsync -avP cedar:~/datasets/ABCD/fmriresults01/abcd-mproc-release5/NDARINV6G63TU7R_baselineYear1Arm1_ABCD-MPROC-rsfMRI_20180427114950.tgz ./
```

List tgz contents:

```bash
./scripts/list_tgz_contents.sh ~/datasets/ABCD ./list_tgz_contents.out
```

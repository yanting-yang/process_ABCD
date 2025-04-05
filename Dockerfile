FROM condaforge/miniforge3:24.11.3-2
RUN pip install --no-cache-dir nibabel nilearn numpy && \
    conda clean -ya

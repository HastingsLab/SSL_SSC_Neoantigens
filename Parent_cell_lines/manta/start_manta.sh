#!/bin/bash
#SBATCH --job-name=Arriba  # Job name
#SBATCH --mail-type=ALL           # notifications for job done & fail
#SBATCH --mail-user=eknodel@asu.edu # send-to address
#SBATCH -N 1
#SBATCH -t 24:00:00
#SBATCH --mem=50000

newgrp combinedlab

source activate var_call_env
module load python/2.7.9

snakemake --snakefile manta_structural_variants.py -j 15 --keep-target-files --rerun-incomplete
#snakemake --snakefile ~/Novel_model/netCTLpan-snakemake.py -j 15 --keep-target-files --rerun-incomplete

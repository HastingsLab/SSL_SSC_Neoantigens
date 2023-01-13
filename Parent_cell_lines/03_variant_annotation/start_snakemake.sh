#!/bin/bash
#SBATCH --job-name=FastQC_Trimmomatic  # Job name
#SBATCH --mail-type=ALL           # notifications for job done & fail
#SBATCH --mail-user=eknodel@asu.edu # send-to address
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -t 12:00:00
#SBATCH --mem=40000
#SBATCH -q tempboost

newgrp combinedlab

source activate salmon_environment

snakemake --snakefile salmon_GENCODE.snakefile -j 15 --keep-target-files --rerun-incomplete --cluster "sbatch -q tempboost -n 1 -c 1 --mem=49000 -t 12:00:00"

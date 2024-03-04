#!/bin/bash
#SBATCH --job-name=Varscan  # Job name
#SBATCH --mail-type=ALL           # notifications for job done & fail
#SBATCH --mail-user=eknodel@asu.edu # send-to address
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -t 168:00:00
#SBATCH --mem=40000
#SBATCH -q tempboost

newgrp combinedlab

source activate cancergenomics

snakemake --snakefile varscan.snakefile -j 15 --keep-target-files --rerun-incomplete --cluster "sbatch -q tempboost -n 1 -c 1 --mem=50000 -t 96:00:00"

#!/bin/bash
#SBATCH --job-name=QC  # Job name
#SBATCH --mail-type=ALL           # notifications for job done & fail
#SBATCH --mail-user=eknodel@asu.edu # send-to address
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -t 168:00:00
#SBATCH --mem=40000
#SBATCH -p wildfire
#SBATCH -q wildfire

newgrp combinedlab

source activate cancergenomics

snakemake --snakefile map.snakefile -j 1 --keep-target-files --rerun-incomplete --cluster "sbatch -p wildfire -q wildfire -n 1 -c 1 --mem=50000 -t 96:00:00"

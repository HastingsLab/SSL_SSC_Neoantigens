#! importing join
from os.path import join

# Workflow for quasi-quantification of RNAseq read counts with Salmon in non-alignment-based mode.
# Samples
sample = ["483_sc_01_B6-1_366_211_S58_L003", "483_sc_01_B6-1_366_211_S58_L003"]

# Tools
SALMON = "salmon"

SALMON_INDEX = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/transcriptome/Mus_musculus_salmon_index/"

# Directories
FQ_DIR = "/scratch/eknodel/SCC_samples/Progeny/RNAseq/trimmed_fastqs/" # path to directory with trimmed FASTQ files
SALMON_DIR = "/scratch/eknodel/SCC_samples/Progeny/RNAseq/salmon_ensembl/" # path to directory for Salmon output files

rule all:
    input:
        expand(SALMON_DIR + "{sample}_ensembl_salmon_quant/", SALMON_DIR=SALMON_DIR, sample=sample),

rule salmon_quant_paired:
    input:
        R1 = os.path.join(FQ_DIR, "{sample}_trimmed_read1.fastq.gz"),
        R2 = os.path.join(FQ_DIR, "{sample}_trimmed_read2.fastq.gz")
    output:
        OUTPUT = directory(os.path.join(SALMON_DIR, "{sample}_ensembl_salmon_quant/"))
    params:
        SALMON = SALMON,
        SALMON_INDEX = SALMON_INDEX,
        LIBTYPE = "A", # LIBTYPE A for automatic detection of library type
        threads = 8
    message: "Quantifying {wildcards.sample} transcripts with Salmon."
    run:
        shell("{params.SALMON} quant -i {params.SALMON_INDEX} -l {params.LIBTYPE} -1 {input.R1} -2 {input.R2} --validateMappings -o {output.OUTPUT}")


#!/bin/sh
# properties = {"type": "single", "rule": "SplitNCigarReads", "local": false, "input": ["/scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/185-1-5c-01-F11-6-26-21-1_216_361_S9_L003_RNA_HISAT2_genome_aligned_sortedbycoord_RG.bam", "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"], "output": ["/scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/185-1-5c-01-F11-6-26-21-1_216_361_S9_L003_RNA_HISAT2_genome_aligned_sortedbycoord_RG-splitreads.bam"], "wildcards": {"subject": "185-1-5c-01-F11-6-26-21-1_216_361_S9_L003"}, "params": {"gatk": "/home/eknodel/gatk-4.1.7.0/gatk"}, "log": [], "threads": 1, "resources": {}, "jobid": 123, "cluster": {}}
cd /home/eknodel/SCC_samples/RNA_mutations && \
/home/eknodel/miniconda3/envs/cancergenomics/bin/python \
-m snakemake /scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/185-1-5c-01-F11-6-26-21-1_216_361_S9_L003_RNA_HISAT2_genome_aligned_sortedbycoord_RG-splitreads.bam --snakefile /home/eknodel/SCC_samples/RNA_mutations/gatk_mutect2.snakefile \
--force -j --keep-target-files --keep-remote \
--wait-for-files /home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.5gsapils /scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/185-1-5c-01-F11-6-26-21-1_216_361_S9_L003_RNA_HISAT2_genome_aligned_sortedbycoord_RG.bam /data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules SplitNCigarReads  && touch "/home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.5gsapils/123.jobfinished" || (touch "/home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.5gsapils/123.jobfailed"; exit 1)


#!/bin/sh
# properties = {"type": "single", "rule": "gatk_asereadcounter", "local": false, "input": ["/scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/244-1-chu-02-B7-6-15-21_214_363_S25_L003_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup.bam", "/scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/244_1_Chu_02_B7_352_225_S2_L003.somatic.filtered.pass.vcf"], "output": ["/scratch/eknodel/SCC_samples/cell_lines/RNAseq/variant_specific_expression/244-1-chu-02-B7-6-15-21_214_363_S25_L003_variant_expression.tsv"], "wildcards": {"sample": "244-1-chu-02-B7-6-15-21_214_363_S25_L003"}, "params": {"gatk": "/home/eknodel/gatk-4.1.7.0/gatk"}, "log": [], "threads": 1, "resources": {}, "jobid": 4, "cluster": {}}
cd /home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression && \
/home/eknodel/miniconda3/envs/cancergenomics/bin/python \
-m snakemake /scratch/eknodel/SCC_samples/cell_lines/RNAseq/variant_specific_expression/244-1-chu-02-B7-6-15-21_214_363_S25_L003_variant_expression.tsv --snakefile /home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression/variant_expression_quantification.snakefile \
--force -j --keep-target-files --keep-remote \
--wait-for-files /home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression/.snakemake/tmp.nyaglrq_ /scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/244-1-chu-02-B7-6-15-21_214_363_S25_L003_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup.bam /scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/244_1_Chu_02_B7_352_225_S2_L003.somatic.filtered.pass.vcf --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules gatk_asereadcounter  && touch "/home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression/.snakemake/tmp.nyaglrq_/4.jobfinished" || (touch "/home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression/.snakemake/tmp.nyaglrq_/4.jobfailed"; exit 1)


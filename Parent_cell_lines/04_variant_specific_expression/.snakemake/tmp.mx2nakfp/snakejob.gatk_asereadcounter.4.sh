#!/bin/sh
# properties = {"type": "single", "rule": "gatk_asereadcounter", "local": false, "input": ["/scratch/eknodel/SCC_samples/Parent_cell_lines/RNAseq/sorted_bam/244-1-chu-02-B7-6-22-21_202_375_S26_L003_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_snps.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_snps.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_snps.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_snps.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_snps.vcf.idx", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_snps.vcf.idx", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_snps.vcf.idx", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_snps.vcf.idx"], "output": ["/scratch/eknodel/SCC_samples/cell_lines/RNAseq/variant_specific_expression/244-1-chu-02-B7-6-22-21_202_375_S26_L003_gatk_filtered_expression.tsv", "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/variant_specific_expression/244-1-chu-02-B7-6-22-21_202_375_S26_L003_gatk_unfiltered_expression.tsv", "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/variant_specific_expression/244-1-chu-02-B7-6-22-21_202_375_S26_L003_strelka_filtered_expression.tsv", "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/variant_specific_expression/244-1-chu-02-B7-6-22-21_202_375_S26_L003_strelka_unfiltered_expression.tsv"], "wildcards": {"RNA": "244-1-chu-02-B7-6-22-21_202_375_S26_L003"}, "params": {"gatk": "/home/eknodel/gatk-4.1.7.0/gatk", "ref": "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"}, "log": [], "threads": 1, "resources": {}, "jobid": 4, "cluster": {}}
cd /home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression && \
/home/eknodel/miniconda3/envs/cancergenomics/bin/python \
-m snakemake /scratch/eknodel/SCC_samples/cell_lines/RNAseq/variant_specific_expression/244-1-chu-02-B7-6-22-21_202_375_S26_L003_gatk_filtered_expression.tsv --snakefile /home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression/variant_expression_quantification.snakefile \
--force -j --keep-target-files --keep-remote \
--wait-for-files /home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression/.snakemake/tmp.mx2nakfp /scratch/eknodel/SCC_samples/Parent_cell_lines/RNAseq/sorted_bam/244-1-chu-02-B7-6-22-21_202_375_S26_L003_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_snps.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_snps.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_snps.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_snps.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_snps.vcf.idx /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_snps.vcf.idx /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_snps.vcf.idx /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_snps.vcf.idx --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules gatk_asereadcounter  && touch "/home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression/.snakemake/tmp.mx2nakfp/4.jobfinished" || (touch "/home/eknodel/SCC_samples/Parent_cell_lines/04_variant_specific_expression/.snakemake/tmp.mx2nakfp/4.jobfailed"; exit 1)


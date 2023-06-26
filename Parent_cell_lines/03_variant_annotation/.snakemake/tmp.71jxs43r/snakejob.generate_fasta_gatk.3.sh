#!/bin/sh
# properties = {"threads": 1, "local": false, "output": ["/scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/244_1_Chu_06_F5_328_249_S4_L003_gatk_vep_unfiltered.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/244_1_Chu_06_F5_328_249_S4_L003_gatk_vep_filtered.vcf"], "input": ["/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_06_F5_328_249_S4_L003_gatk_vep_unfiltered.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_06_F5_328_249_S4_L003_gatk_vep_filtered.vcf"], "rule": "generate_fasta_gatk", "cluster": {}, "resources": {}, "jobid": 3, "params": {"sample": "244_1_Chu_06_F5_328_249_S4_L003"}}
cd /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation && \
/home/eknodel/miniconda3/envs/var_call_env/bin/python -m snakemake /scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/244_1_Chu_06_F5_328_249_S4_L003_gatk_vep_unfiltered.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/244_1_Chu_06_F5_328_249_S4_L003_gatk_vep_filtered.vcf --snakefile /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/VEP_PVACseq_updated.snakefile \
--force -j --keep-target-files --keep-shadow --keep-remote \
--wait-for-files /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_06_F5_328_249_S4_L003_gatk_vep_unfiltered.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/244_1_Chu_06_F5_328_249_S4_L003_gatk_vep_filtered.vcf /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.71jxs43r --latency-wait 5 \
--benchmark-repeats 1 \
--force-use-threads --wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --quiet --no-hooks --nolock --force-use-threads  --allowed-rules generate_fasta_gatk  && touch "/home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.71jxs43r/3.jobfinished" || (touch "/home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.71jxs43r/3.jobfailed"; exit 1)


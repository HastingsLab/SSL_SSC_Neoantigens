#!/bin/sh
# properties = {"threads": 1, "local": false, "output": ["/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/185_1_SC_09_G9_304_273_S6_L003_gatk_vep_unfiltered.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/185_1_SC_09_G9_304_273_S6_L003_strelka_vep_unfiltered.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/185_1_SC_09_G9_304_273_S6_L003_gatk_vep_filtered.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/185_1_SC_09_G9_304_273_S6_L003_strelka_vep_filtered.vcf"], "input": ["/scratch/eknodel/SCC_samples/Parent_cell_lines/gatk_mutect2/185_1_SC_09_G9_304_273_S6_L003.somatic_sorted.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/strelka/185_1_SC_09_G9_304_273_S6_L003/results/variants/somatic_sorted.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/gatk_mutect2/185_1_SC_09_G9_304_273_S6_L003.somatic_sorted.filtered.pass.vcf", "/scratch/eknodel/SCC_samples/Parent_cell_lines/strelka/185_1_SC_09_G9_304_273_S6_L003/results/variants/somatic_sorted.pass.vcf"], "rule": "run_vep", "cluster": {}, "resources": {}, "jobid": 24, "params": {}}
cd /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation && \
/home/eknodel/miniconda3/envs/var_call_env/bin/python -m snakemake /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/185_1_SC_09_G9_304_273_S6_L003_gatk_vep_unfiltered.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/185_1_SC_09_G9_304_273_S6_L003_strelka_vep_unfiltered.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/185_1_SC_09_G9_304_273_S6_L003_gatk_vep_filtered.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/185_1_SC_09_G9_304_273_S6_L003_strelka_vep_filtered.vcf --snakefile /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/VEP_PVACseq_updated.snakefile \
--force -j --keep-target-files --keep-shadow --keep-remote \
--wait-for-files /scratch/eknodel/SCC_samples/Parent_cell_lines/gatk_mutect2/185_1_SC_09_G9_304_273_S6_L003.somatic_sorted.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/strelka/185_1_SC_09_G9_304_273_S6_L003/results/variants/somatic_sorted.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/gatk_mutect2/185_1_SC_09_G9_304_273_S6_L003.somatic_sorted.filtered.pass.vcf /scratch/eknodel/SCC_samples/Parent_cell_lines/strelka/185_1_SC_09_G9_304_273_S6_L003/results/variants/somatic_sorted.pass.vcf /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.71jxs43r --latency-wait 5 \
--benchmark-repeats 1 \
--force-use-threads --wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --quiet --no-hooks --nolock --force-use-threads  --allowed-rules run_vep  && touch "/home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.71jxs43r/24.jobfinished" || (touch "/home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.71jxs43r/24.jobfailed"; exit 1)


#!/bin/sh
# properties = {"threads": 1, "local": false, "output": ["/scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/244_1_Chu_02_B7_352_225_S2_L003_strelka_netmhc.xsl", "/scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/244_1_Chu_02_B7_352_225_S2_L003_gatk_netmhc.xsl"], "cluster": {}, "input": ["/scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered.peptide_formatted", "/scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered.peptide_formatted"], "jobid": 1, "resources": {}, "rule": "netMHC", "params": {"hla": "H-2-Dd,H-2-Kd,H-2-Ld"}}
cd /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation && \
/home/eknodel/miniconda3/envs/var_call_env/bin/python -m snakemake /scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/244_1_Chu_02_B7_352_225_S2_L003_strelka_netmhc.xsl /scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/244_1_Chu_02_B7_352_225_S2_L003_gatk_netmhc.xsl --snakefile /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/netMHCpan-snakemake.py \
--force -j --keep-target-files --keep-shadow --keep-remote \
--wait-for-files /scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered.peptide_formatted /scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered.peptide_formatted /home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.1hlp7tmk --latency-wait 5 \
--benchmark-repeats 1 \
--force-use-threads --wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --quiet --no-hooks --nolock --force-use-threads  --allowed-rules netMHC  && touch "/home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.1hlp7tmk/1.jobfinished" || (touch "/home/eknodel/SCC_samples/Parent_cell_lines/03_variant_annotation/.snakemake/tmp.1hlp7tmk/1.jobfailed"; exit 1)


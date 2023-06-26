#!/bin/sh
# properties = {"rule": "netMHC_WT", "input": ["/scratch/eknodel/SCC_samples/Progeny/peptides/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_vep_filtered.WT_peptide_formatted", "/scratch/eknodel/SCC_samples/Progeny/peptides/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered.WT_peptide_formatted"], "local": false, "output": ["/scratch/eknodel/SCC_samples/Progeny/netMHCpan/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_WT_gatk_netmhc.xsl", "/scratch/eknodel/SCC_samples/Progeny/netMHCpan/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_WT_strelka_netmhc.xsl"], "resources": {}, "cluster": {}, "threads": 1, "params": {"hla": "H-2-Dd,H-2-Kd,H-2-Ld"}, "jobid": 1}
cd /home/eknodel/SCC_samples/Progeny/03_variant_annotation && \
/home/eknodel/miniconda3/envs/var_call_env/bin/python -m snakemake /scratch/eknodel/SCC_samples/Progeny/netMHCpan/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_WT_gatk_netmhc.xsl /scratch/eknodel/SCC_samples/Progeny/netMHCpan/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_WT_strelka_netmhc.xsl --snakefile /home/eknodel/SCC_samples/Progeny/03_variant_annotation/netMHCpan-snakemake.py \
--force -j --keep-target-files --keep-shadow --keep-remote \
--wait-for-files /scratch/eknodel/SCC_samples/Progeny/peptides/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_vep_filtered.WT_peptide_formatted /scratch/eknodel/SCC_samples/Progeny/peptides/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered.WT_peptide_formatted /home/eknodel/SCC_samples/Progeny/03_variant_annotation/.snakemake/tmp.rgsok5uh --latency-wait 5 \
--benchmark-repeats 1 \
--force-use-threads --wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --quiet --no-hooks --nolock --force-use-threads  --allowed-rules netMHC_WT  && touch "/home/eknodel/SCC_samples/Progeny/03_variant_annotation/.snakemake/tmp.rgsok5uh/1.jobfinished" || (touch "/home/eknodel/SCC_samples/Progeny/03_variant_annotation/.snakemake/tmp.rgsok5uh/1.jobfailed"; exit 1)


#!/bin/sh
# properties = {"params": {"hla": "H-2-Dd,H-2-Kd,H-2-Ld"}, "output": ["/scratch/eknodel/SCC_samples/Progeny/netMHCpan/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_netmhc.xsl", "/scratch/eknodel/SCC_samples/Progeny/netMHCpan/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_netmhc.xsl"], "cluster": {}, "rule": "netMHC", "input": ["/scratch/eknodel/SCC_samples/Progeny/peptides/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered.peptide_formatted", "/scratch/eknodel/SCC_samples/Progeny/peptides/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_vep_filtered.peptide_formatted"], "local": false, "jobid": 1, "threads": 1, "resources": {}}
cd /home/eknodel/SCC_samples/Progeny/03_variant_annotation && \
/home/eknodel/miniconda3/envs/var_call_env/bin/python -m snakemake /scratch/eknodel/SCC_samples/Progeny/netMHCpan/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_netmhc.xsl /scratch/eknodel/SCC_samples/Progeny/netMHCpan/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_netmhc.xsl --snakefile /home/eknodel/SCC_samples/Progeny/03_variant_annotation/netMHCpan-snakemake.py \
--force -j --keep-target-files --keep-shadow --keep-remote \
--wait-for-files /scratch/eknodel/SCC_samples/Progeny/peptides/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered.peptide_formatted /scratch/eknodel/SCC_samples/Progeny/peptides/DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_vep_filtered.peptide_formatted /home/eknodel/SCC_samples/Progeny/03_variant_annotation/.snakemake/tmp.p_amk2v7 --latency-wait 5 \
--benchmark-repeats 1 \
--force-use-threads --wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --quiet --no-hooks --nolock --force-use-threads  --allowed-rules netMHC  && touch "/home/eknodel/SCC_samples/Progeny/03_variant_annotation/.snakemake/tmp.p_amk2v7/1.jobfinished" || (touch "/home/eknodel/SCC_samples/Progeny/03_variant_annotation/.snakemake/tmp.p_amk2v7/1.jobfailed"; exit 1)


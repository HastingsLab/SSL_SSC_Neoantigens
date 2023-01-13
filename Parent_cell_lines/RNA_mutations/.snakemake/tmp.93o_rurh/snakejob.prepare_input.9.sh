#!/bin/sh
# properties = {"rule": "prepare_input", "params": {}, "cluster": {}, "output": ["/scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/peptides/188.29.peptide_formatted"], "input": ["/scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/peptides/188_vep.29.peptide"], "local": false, "jobid": 9, "resources": {}, "threads": 1}
cd /home/eknodel/SCC_samples/RNA_mutations && \
/home/eknodel/miniconda3/envs/var_call_env/bin/python -m snakemake /scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/peptides/188.29.peptide_formatted --snakefile /home/eknodel/SCC_samples/RNA_mutations/netMHCpanII-snakemake.py \
--force -j --keep-target-files --keep-shadow --keep-remote \
--wait-for-files /scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/peptides/188_vep.29.peptide /home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.93o_rurh --latency-wait 5 \
--benchmark-repeats 1 \
--force-use-threads --wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --quiet --no-hooks --nolock --force-use-threads  --allowed-rules prepare_input  && touch "/home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.93o_rurh/9.jobfinished" || (touch "/home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.93o_rurh/9.jobfailed"; exit 1)


#!/bin/sh
# properties = {"type": "single", "rule": "tumor_only", "local": false, "input": ["/data/CEM/shared/public_data/references/GENCODE_Mus_musculus/gencode.vM27.transcripts.fa", "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/244-1-chu-02-B7-6-11-21_226_351_S24_L003_RNA_HISAT2_aligned_sortedbycoord_RG.bam"], "output": ["/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_haplotype_caller/244-1-chu-02-B7-6-11-21_226_351_S24_L003.somatic.vcf.gz"], "wildcards": {"subject": "244-1-chu-02-B7-6-11-21_226_351_S24_L003"}, "params": {"gatk": "/home/eknodel/gatk-4.1.7.0/gatk"}, "log": [], "threads": 1, "resources": {}, "jobid": 1, "cluster": {}}
cd /home/eknodel/SCC_samples/RNA_mutations && \
/home/eknodel/miniconda3/envs/cancergenomics/bin/python \
-m snakemake /scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_haplotype_caller/244-1-chu-02-B7-6-11-21_226_351_S24_L003.somatic.vcf.gz --snakefile /home/eknodel/SCC_samples/RNA_mutations/gatk_haplotypecaller.snakefile \
--force -j --keep-target-files --keep-remote \
--wait-for-files /home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.ldpux9bv /data/CEM/shared/public_data/references/GENCODE_Mus_musculus/gencode.vM27.transcripts.fa /scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/244-1-chu-02-B7-6-11-21_226_351_S24_L003_RNA_HISAT2_aligned_sortedbycoord_RG.bam --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules tumor_only  && touch "/home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.ldpux9bv/1.jobfinished" || (touch "/home/eknodel/SCC_samples/RNA_mutations/.snakemake/tmp.ldpux9bv/1.jobfailed"; exit 1)


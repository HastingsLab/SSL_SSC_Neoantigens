# Setting up filesnames here:
from os.path import join
import os

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]

# Directory Pathways
gatk_path = "/scratch/eknodel/SCC_samples/Progeny/gatk_mutect2/"
peptide_path = "/scratch/eknodel/SCC_samples/Progeny/peptides/"
strelka_dir = "/scratch/eknodel/SCC_samples/Progeny/strelka/"
vep_path = "/scratch/eknodel/SCC_samples/Progeny/VEP/"


rule all:
    input:
        expand(vep_path + "{sample}_mnp_split_gatk_vep_filtered.vcf", sample=sample, vep_path=vep_path),

rule sort_input: 
    input: 
        gatk_filtered = os.path.join(gatk_path, "{sample}_mnp_split.somatic.filtered.pass.vcf")
    output: 
        gatk_filtered = os.path.join(gatk_path, "{sample}_mnp_split.somatic_sorted.filtered.pass.vcf")
    shell:
        """
        bcftools sort {input.gatk_filtered} -o {output.gatk_filtered};
        """

rule run_vep:
    input:
        gatk_filtered = os.path.join(gatk_path, "{sample}_mnp_split.somatic_sorted.filtered.pass.vcf"),
    output:
        gatk_filtered = os.path.join(vep_path, "{sample}_mnp_split_gatk_vep_filtered.vcf"),
    shell:
        """
        vep -i {input.gatk_filtered} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output.gatk_filtered} --force_overwrite  --symbol --plugin Wildtype --plugin Frameshift --terms SO --plugin Downstream;
        """ 


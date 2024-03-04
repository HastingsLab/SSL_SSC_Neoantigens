# Setting up filesnames here:
from os.path import join
import os

#sample = ["185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_D12_316_261_S5_L003", "244_1_Chu_06_F5_328_249_S4_L003",
#"185_1_SC_09_G9_304_273_S6_L003", "188_2_SC_05_F11_340_237_S3_L003", "244_1_Chu_02_B7_352_225_S2_L003"]
sample = ["244_1_Chu_02_B7_352_225_S2_L003"]

# Directory Pathways
gatk_path = "/scratch/eknodel/SCC_samples/Parent_cell_lines/gatk_mutect2/"
peptide_path = "/scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/"
strelka_dir = "/scratch/eknodel/SCC_samples/Parent_cell_lines/strelka/"
vep_path = "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/"


rule all:
    input:
        expand(vep_path + "{sample}_mnp_split_gatk_vep_filtered.vcf", sample=sample, vep_path=vep_path),
        expand(vep_path + "{sample}_mnp_split_gatk_vep.vcf", sample=sample, vep_path=vep_path)

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


## Unfiltered GATK - run for 244B7 only for parent/progeny rescues
rule sort_input_unfiltered:
    input:
        gatk_filtered = os.path.join(gatk_path, "{sample}_mnp_split.somatic.vcf")
    output:
        gatk_filtered = os.path.join(gatk_path, "{sample}_mnp_split.somatic_sorted.vcf")
    shell:
        """
        bcftools sort {input.gatk_filtered} -o {output.gatk_filtered};
        """

rule run_vep_unfiltered:
    input:
        gatk_filtered = os.path.join(gatk_path, "{sample}_mnp_split.somatic_sorted.vcf"),
    output:
        gatk_filtered = os.path.join(vep_path, "{sample}_mnp_split_gatk_vep.vcf"),
    shell:
        """
        vep -i {input.gatk_filtered} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output.gatk_filtered} --force_overwrite  --symbol --plugin Wildtype --plugin Frameshift --terms SO --plugin Downstream;
        """
